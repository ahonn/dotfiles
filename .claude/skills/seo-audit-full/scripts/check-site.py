#!/usr/bin/env python3
"""
Site-level SEO checks: staging subdomains, robots.txt, and sitemap.xml.
Outputs structured JSON to stdout so the agent can consume results directly
without needing to interpret raw HTTP responses or parse formats manually.

Usage:
    python check-site.py https://example.com
    python check-site.py https://example.com --timeout 15

Output example (JSON):
    {
      "origin": "https://example.com",
      "staging_subdomains": {
        "status": "pass",
        "checked_hosts": ["test.example.com", "staging.example.com"],
        "public_hosts": [],
        "detail": "No public staging/test subdomain detected."
      },
      "robots": {
        "status": "pass",
        "http_status": 200,
        "disallow_all": false,
        "googlebot_blocked": false,
        "sitemap_directive": "https://example.com/sitemap.xml",
        "detail": "robots.txt found. No critical blocking rules detected."
      },
      "sitemap": {
        "status": "pass",
        "http_status": 200,
        "url_count": 42,
        "is_index": false,
        "detail": "sitemap.xml found with 42 URLs."
      }
    }

Dependencies:
    pip install requests
"""

import argparse
import ipaddress
import json
import re
import socket
import sys
import xml.etree.ElementTree as ET
from difflib import SequenceMatcher
from typing import Optional
from urllib.parse import urlparse

try:
    import requests
except ImportError:
    print("Error: requests library required. Install with: pip install requests", file=sys.stderr)
    sys.exit(1)


# Same UA as fetch-page.py for consistent request fingerprinting
_DEFAULT_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 ClaudeSEO/1.2"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Connection": "keep-alive",
}

_STAGING_PREFIXES = ("test", "staging", "dev", "preview", "beta", "uat")
_PROTECTED_STATUS_CODES = {401, 403}
_PUBLIC_STATUS_CODES = {200}
_MAX_SITEMAP_CHILDREN = 20
_MAX_INVENTORY_URLS = 5000


def _safe_fetch(url: str, timeout: int) -> tuple[Optional[int], Optional[str], Optional[str]]:
    """
    Internal helper: fetch a URL safely with SSRF protection.
    Returns (status_code, content, error_message).
    """
    parsed = urlparse(url)

    # SSRF protection: block private, loopback, and reserved IPs
    try:
        hostname = parsed.hostname or ""
        resolved_ip = socket.gethostbyname(hostname)
        ip = ipaddress.ip_address(resolved_ip)
        if ip.is_private or ip.is_loopback or ip.is_reserved:
            return None, None, f"Blocked: resolves to private IP ({resolved_ip})"
    except (socket.gaierror, ValueError):
        pass

    try:
        resp = requests.get(url, headers=_DEFAULT_HEADERS, timeout=timeout, allow_redirects=True)
        return resp.status_code, resp.text, None
    except requests.exceptions.Timeout:
        return None, None, f"Timed out after {timeout}s"
    except requests.exceptions.SSLError as e:
        return None, None, f"SSL error: {e}"
    except requests.exceptions.ConnectionError as e:
        return None, None, f"Connection error: {e}"
    except requests.exceptions.RequestException as e:
        return None, None, f"Request failed: {e}"


def _safe_fetch_no_redirect(
    url: str, timeout: int
) -> tuple[Optional[int], Optional[str], Optional[str], Optional[str]]:
    """
    Fetch a URL without following redirects.
    Returns (status_code, content, error_message, location_header).
    """
    parsed = urlparse(url)

    try:
        hostname = parsed.hostname or ""
        resolved_ip = socket.gethostbyname(hostname)
        ip = ipaddress.ip_address(resolved_ip)
        if ip.is_private or ip.is_loopback or ip.is_reserved:
            return None, None, f"Blocked: resolves to private IP ({resolved_ip})", None
    except (socket.gaierror, ValueError):
        pass

    try:
        resp = requests.get(url, headers=_DEFAULT_HEADERS, timeout=timeout, allow_redirects=False)
        return resp.status_code, resp.text, None, resp.headers.get("Location")
    except requests.exceptions.Timeout:
        return None, None, f"Timed out after {timeout}s", None
    except requests.exceptions.SSLError as e:
        return None, None, f"SSL error: {e}", None
    except requests.exceptions.ConnectionError as e:
        return None, None, f"Connection error: {e}", None
    except requests.exceptions.RequestException as e:
        return None, None, f"Request failed: {e}", None


def _parse_robots_groups(content: str) -> tuple[list[dict], list[str]]:
    """
    Parse robots.txt into directive groups per RFC 9309.
    Consecutive User-Agent lines merge into one group.
    Returns (groups, sitemap_directives).
    """
    groups: list[dict] = []
    current_group: Optional[dict] = None
    prev_key = ""
    sitemap_directives: list[str] = []

    for raw_line in content.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            continue

        key, _, value = line.partition(":")
        key = key.strip().lower()
        value = value.strip()

        if key == "user-agent":
            if prev_key == "user-agent" and current_group is not None:
                current_group["agents"].append(value.lower())
            else:
                current_group = {
                    "agents": [value.lower()],
                    "allow": [],
                    "disallow": [],
                }
                groups.append(current_group)
            prev_key = "user-agent"
        elif key in ("allow", "disallow") and current_group is not None:
            if value:
                current_group[key].append(value)
            prev_key = key
        elif key == "sitemap":
            if value:
                sitemap_directives.append(value)
            prev_key = key
        else:
            prev_key = key

    return groups, sitemap_directives


def _group_blocks_all(group: dict) -> bool:
    """
    Check if a group fully blocks the site.
    Disallow: / alone blocks everything, but Allow: sub-paths means partial access.
    Per RFC 9309, the most specific (longest) matching rule wins.
    """
    has_root_block = any(rule in ("/", "/*") for rule in group.get("disallow", []))
    if not has_root_block:
        return False
    # Allow rules for sub-paths override the root block → not a full block
    has_allow = any(r and r != "/" for r in group.get("allow", []))
    return not has_allow


def _find_group_for_agent(groups: list[dict], agent: str) -> Optional[dict]:
    """Find the group matching a specific user agent name."""
    agent_lower = agent.lower()
    for group in groups:
        if agent_lower in group["agents"]:
            return group
    return None


def _html_has_noindex(content: str) -> bool:
    """Return True when HTML contains a robots noindex directive."""
    meta_pattern = re.compile(
        r"<meta[^>]+(?:name|property)=[\"']?(?:robots|googlebot)[\"']?[^>]*>",
        re.IGNORECASE,
    )
    for tag in meta_pattern.findall(content or ""):
        if "noindex" in tag.lower():
            return True
    return False


def _extract_visible_text(content: str) -> str:
    """Normalize visible-ish page text for rough production/staging similarity checks."""
    text = re.sub(r"(?is)<(script|style|noscript|svg)[^>]*>.*?</\1>", " ", content or "")
    text = re.sub(r"(?is)<!--.*?-->", " ", text)
    text = re.sub(r"(?is)<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip().lower()[:12000]


def _content_similarity(a: Optional[str], b: Optional[str]) -> Optional[float]:
    """Return a rough text similarity score between two HTML documents."""
    if not a or not b:
        return None
    text_a = _extract_visible_text(a)
    text_b = _extract_visible_text(b)
    if len(text_a) < 200 or len(text_b) < 200:
        return None
    return round(SequenceMatcher(None, text_a, text_b).ratio(), 3)


def _robots_blocks_all(content: Optional[str]) -> bool:
    """Check whether robots.txt content blocks all crawlers or Googlebot."""
    if not content:
        return False
    groups, _ = _parse_robots_groups(content)
    wildcard_group = _find_group_for_agent(groups, "*")
    googlebot_group = _find_group_for_agent(groups, "googlebot")
    wildcard_blocked = _group_blocks_all(wildcard_group) if wildcard_group else False
    googlebot_blocked = _group_blocks_all(googlebot_group) if googlebot_group else wildcard_blocked
    return wildcard_blocked or googlebot_blocked


def check_robots(origin: str, timeout: int) -> dict:
    """
    Check robots.txt with RFC 9309-compliant group parsing.
    Handles Allow overrides, multi-agent groups, and multiple Sitemap directives.
    """
    url = f"{origin}/robots.txt"
    status_code, content, error = _safe_fetch(url, timeout)

    result: dict = {
        "status": "error",
        "http_status": status_code,
        "disallow_all": False,
        "googlebot_blocked": False,
        "sitemap_directives": [],
        "sitemap_directive": None,
        "detail": "",
    }

    if error:
        result["detail"] = f"Fetch error: {error}"
        return result

    if status_code != 200:
        result["status"] = "fail"
        result["detail"] = f"robots.txt returned HTTP {status_code}. File may not exist or is inaccessible."
        return result

    if not content:
        result["status"] = "warn"
        result["detail"] = "robots.txt returned HTTP 200 but body is empty."
        return result

    groups, sitemap_directives = _parse_robots_groups(content)
    result["sitemap_directives"] = sitemap_directives
    result["sitemap_directive"] = sitemap_directives[0] if sitemap_directives else None

    # Evaluate blocking: Googlebot uses its own group if present, else inherits *
    wildcard_group = _find_group_for_agent(groups, "*")
    wildcard_blocked = _group_blocks_all(wildcard_group) if wildcard_group else False

    googlebot_group = _find_group_for_agent(groups, "googlebot")
    if googlebot_group:
        googlebot_blocked = _group_blocks_all(googlebot_group)
    else:
        googlebot_blocked = wildcard_blocked

    result["disallow_all"] = wildcard_blocked or googlebot_blocked
    result["googlebot_blocked"] = googlebot_blocked

    issues: list[str] = []
    if googlebot_blocked and wildcard_blocked:
        issues.append("Disallow: / blocks all crawlers including Googlebot.")
    elif googlebot_blocked:
        issues.append("Googlebot is explicitly blocked by its own Disallow: / rule.")
    elif wildcard_blocked:
        issues.append(
            "Disallow: / for User-Agent: * blocks most crawlers "
            "(Googlebot not specifically overridden)."
        )
    elif wildcard_group and any(d in ("/", "/*") for d in wildcard_group.get("disallow", [])):
        # Disallow: / exists but Allow rules partially override it
        allow_paths = [r for r in wildcard_group.get("allow", []) if r and r != "/"]
        if allow_paths:
            paths_str = ", ".join(allow_paths[:5])
            issues.append(
                f"Disallow: / present but partially overridden by Allow: {paths_str}. "
                "Site is not fully blocked."
            )

    if not sitemap_directives:
        issues.append("No Sitemap: directive found in robots.txt.")

    if googlebot_blocked:
        result["status"] = "fail"
    elif issues:
        result["status"] = "warn"
    else:
        result["status"] = "pass"

    if issues:
        result["detail"] = " ".join(issues)
    else:
        sitemap_note = (
            f" Sitemap: {', '.join(sitemap_directives)}."
            if sitemap_directives else ""
        )
        result["detail"] = f"robots.txt found. No critical blocking rules detected.{sitemap_note}"

    return result


def _local_name(tag: str) -> str:
    """Return XML tag local name without namespace."""
    return re.sub(r"\{.*?\}", "", tag).lower()


def _extract_sitemap_locs(root: ET.Element, item_tag: str) -> list[str]:
    """Extract <loc> values from sitemap or url entries."""
    locs: list[str] = []
    for item in root:
        if _local_name(item.tag) != item_tag:
            continue
        for child in item:
            if _local_name(child.tag) == "loc" and child.text:
                locs.append(child.text.strip())
                break
    return locs


def _parse_sitemap_xml(content: str, source_url: str) -> dict:
    """Parse and validate a single sitemap XML document."""
    try:
        root = ET.fromstring(content)
    except ET.ParseError as e:
        return {"status": "fail", "detail": f"Sitemap at {source_url} is not valid XML: {e}"}

    tag = _local_name(root.tag)

    if tag == "sitemapindex":
        child_sitemaps = _extract_sitemap_locs(root, "sitemap")
        child_count = len(child_sitemaps)
        return {
            "status": "pass" if child_count > 0 else "warn",
            "is_index": True,
            "url_count": child_count,
            "urls": [],
            "child_sitemaps": child_sitemaps,
            "detail": (
                f"Sitemap index at {source_url} with {child_count} child sitemap(s)."
                if child_count > 0
                else f"Sitemap index at {source_url} contains no child sitemaps."
            ),
        }

    if tag == "urlset":
        urls = _extract_sitemap_locs(root, "url")
        url_count = len(urls)
        return {
            "status": "pass" if url_count > 0 else "warn",
            "is_index": False,
            "url_count": url_count,
            "urls": urls,
            "child_sitemaps": [],
            "detail": (
                f"Sitemap at {source_url} with {url_count} URL(s)."
                if url_count > 0
                else f"Sitemap at {source_url} contains no <url> entries."
            ),
        }

    return {"status": "warn", "detail": f"Sitemap at {source_url} has unexpected root element: <{tag}>."}


def check_sitemap(
    origin: str, timeout: int, sitemap_urls: Optional[list[str]] = None
) -> dict:
    """
    Check sitemap for accessibility and valid XML structure.
    Tries URLs declared in robots.txt first, then falls back to {origin}/sitemap.xml.
    """
    candidates: list[str] = list(sitemap_urls) if sitemap_urls else []
    default_url = f"{origin}/sitemap.xml"
    if default_url not in candidates:
        candidates.append(default_url)

    result: dict = {
        "status": "error",
        "http_status": None,
        "url_count": 0,
        "is_index": False,
        "checked_url": None,
        "urls": [],
        "child_sitemaps": [],
        "detail": "",
    }

    for candidate in candidates:
        status_code, content, error = _safe_fetch(candidate, timeout)
        result["checked_url"] = candidate
        result["http_status"] = status_code

        if error or status_code == 404 or status_code is None:
            continue

        if status_code != 200:
            result["status"] = "warn"
            result["detail"] = f"Sitemap at {candidate} returned HTTP {status_code}."
            return result

        if not content:
            continue

        parsed = _parse_sitemap_xml(content, candidate)
        result["status"] = parsed["status"]
        result["is_index"] = parsed.get("is_index", False)
        result["url_count"] = parsed.get("url_count", 0)
        result["urls"] = parsed.get("urls", [])
        result["child_sitemaps"] = parsed.get("child_sitemaps", [])
        result["detail"] = parsed["detail"]

        if result["is_index"] and result["child_sitemaps"]:
            collected_urls: list[str] = []
            checked_children = result["child_sitemaps"][:_MAX_SITEMAP_CHILDREN]
            for child_url in checked_children:
                child_status, child_content, child_error = _safe_fetch(child_url, timeout)
                if child_error or child_status != 200 or not child_content:
                    continue
                child_parsed = _parse_sitemap_xml(child_content, child_url)
                if child_parsed.get("is_index"):
                    continue
                collected_urls.extend(child_parsed.get("urls", []))
                if len(collected_urls) >= _MAX_INVENTORY_URLS:
                    collected_urls = collected_urls[:_MAX_INVENTORY_URLS]
                    break
            if collected_urls:
                result["urls"] = collected_urls
                result["url_count"] = len(collected_urls)
                result["detail"] = (
                    f"Sitemap index at {candidate} with {len(result['child_sitemaps'])} child sitemap(s). "
                    f"Sampled {len(collected_urls)} URL(s) from {len(checked_children)} child sitemap(s)."
                )
        return result

    # None of the candidates were accessible
    checked = ", ".join(candidates)
    result["status"] = "fail"
    result["detail"] = (
        f"No accessible sitemap found. Checked: {checked}. "
        "Ensure a valid XML sitemap exists and is referenced in robots.txt."
    )
    return result


def _directory_for_url(url: str) -> str:
    """Return the first-level directory for inventory grouping."""
    path = urlparse(url).path or "/"
    if path in ("", "/"):
        return "/"
    parts = [part for part in path.split("/") if part]
    if not parts:
        return "/"
    return f"/{parts[0]}/"


def _classify_directory(directory: str) -> tuple[str, str, str]:
    """Infer page type, SEO role, and next step from a URL directory."""
    directory_lower = directory.lower()
    rules = [
        (("blog", "article", "post", "news", "story"), "Blog / Content Pages", "Informational keyword capture", "Audit representative articles for keyword targeting, schema, internal links, and content quality."),
        (("tools", "tool"), "Tool Pages", "Utility-led search demand", "Run full audit on high-value tool pages and check indexability, intent match, and conversion paths."),
        (("alternatives", "alternative", "compare", "comparison", "vs"), "Alternative / Competitor Pages", "Competitor and comparison keywords", "Audit representative comparison pages for differentiation, canonicalization, and conversion intent."),
        (("templates", "template"), "Template Pages", "Template and downloadable asset demand", "Audit representative template pages for thin content, schema, preview quality, and internal links."),
        (("use-cases", "use-case", "solutions", "solution"), "Use Case / Solution Pages", "Problem-aware and vertical intent", "Audit representative use case pages for intent match, proof, internal links, and CTA alignment."),
        (("pricing", "plans"), "Pricing Pages", "Commercial evaluation intent", "Audit pricing pages for indexability, SERP snippet control, schema, and conversion clarity."),
        (("docs", "documentation", "help", "support", "guide", "guides"), "Documentation / Support Pages", "Long-tail support and product education", "Audit docs pages for crawl depth, duplication, canonical tags, and internal search demand."),
        (("product", "products", "features", "feature"), "Product / Feature Pages", "Product-led commercial intent", "Audit feature pages for keyword mapping, schema, internal links, and conversion paths."),
    ]
    for needles, page_type, seo_role, next_step in rules:
        if any(needle in directory_lower for needle in needles):
            return page_type, seo_role, next_step
    return (
        "Other Pages",
        "Unclassified sitemap segment",
        "Review sample URLs to decide whether this directory needs a deeper full audit.",
    )


def build_sitemap_inventory(sitemap_result: dict, top_n: int = 12) -> dict:
    """Summarize sitemap URLs by first-level directory and inferred SEO page type."""
    urls = sitemap_result.get("urls", []) or []
    result: dict = {
        "status": "info",
        "total_urls": len(urls),
        "directories": [],
        "detail": "No sitemap URLs available for inventory.",
    }
    if not urls:
        result["status"] = "warn" if sitemap_result.get("status") in ("pass", "warn") else "error"
        return result

    grouped: dict[str, dict] = {}
    for url in urls:
        directory = _directory_for_url(url)
        bucket = grouped.setdefault(directory, {"path": directory, "url_count": 0, "sample_urls": []})
        bucket["url_count"] += 1
        if len(bucket["sample_urls"]) < 3:
            bucket["sample_urls"].append(url)

    directories = sorted(grouped.values(), key=lambda item: item["url_count"], reverse=True)[:top_n]
    for item in directories:
        page_type, seo_role, next_step = _classify_directory(item["path"])
        item["page_type"] = page_type
        item["seo_role"] = seo_role
        item["recommended_next_step"] = next_step
        item["example_url"] = item["sample_urls"][0] if item["sample_urls"] else None

    result["directories"] = directories
    result["detail"] = (
        f"Sitemap contains {len(urls)} URL(s) across {len(grouped)} first-level directories. "
        "Use this as a site-level map, then run full audit on representative sample URLs."
    )
    return result


def _staging_candidates(origin: str) -> list[str]:
    """Build common staging/test origins from the production origin."""
    parsed = urlparse(origin)
    hostname = parsed.hostname or ""
    scheme = parsed.scheme or "https"

    host_parts = hostname.split(".")
    if len(host_parts) < 2:
        return []

    base_host = hostname
    if host_parts[0] == "www" or host_parts[0] in _STAGING_PREFIXES:
        base_host = ".".join(host_parts[1:])

    candidates = []
    for prefix in _STAGING_PREFIXES:
        candidate_host = f"{prefix}.{base_host}"
        if candidate_host != hostname:
            candidates.append(f"{scheme}://{candidate_host}")
    return candidates


def check_staging_subdomains(origin: str, timeout: int) -> dict:
    """
    Check common staging/test subdomains for public duplicate indexation risk.
    This is a public-signal check; it does not query Google site: results.
    """
    candidates = _staging_candidates(origin)
    checked_hosts = [urlparse(candidate).hostname for candidate in candidates]
    result: dict = {
        "status": "pass",
        "checked_hosts": checked_hosts,
        "public_hosts": [],
        "protected_hosts": [],
        "redirected_hosts": [],
        "similar_hosts": [],
        "detail": "No public staging/test subdomain detected.",
    }

    production_status, production_html, production_error = _safe_fetch(origin, timeout)
    production_available = production_status == 200 and bool(production_html) and not production_error

    for candidate in candidates:
        host = urlparse(candidate).hostname or candidate
        status_code, content, error, location = _safe_fetch_no_redirect(candidate, timeout)

        if error or status_code is None:
            continue

        if status_code in _PROTECTED_STATUS_CODES:
            result["protected_hosts"].append(host)
            continue

        if 300 <= status_code < 400:
            result["redirected_hosts"].append({"host": host, "location": location})
            continue

        if status_code not in _PUBLIC_STATUS_CODES:
            continue

        robots_status, robots_content, robots_error = _safe_fetch(f"{candidate}/robots.txt", timeout)
        robots_blocked = (
            robots_status == 200 and not robots_error and _robots_blocks_all(robots_content)
        )
        noindex = _html_has_noindex(content or "")
        similarity = _content_similarity(production_html, content) if production_available else None

        public_host = {
            "host": host,
            "status_code": status_code,
            "robots_blocked": robots_blocked,
            "noindex": noindex,
            "similarity": similarity,
        }
        result["public_hosts"].append(public_host)

        if robots_blocked or noindex:
            result["protected_hosts"].append(host)
            continue

        if similarity is not None and similarity >= 0.82:
            result["similar_hosts"].append(public_host)

    if result["similar_hosts"]:
        hosts = ", ".join(item["host"] for item in result["similar_hosts"])
        result["status"] = "fail"
        result["detail"] = (
            f"Public staging/test subdomain mirrors production: {hosts}. "
            "Protect staging with authentication or block crawlers with User-agent: * / Disallow: /."
        )
    else:
        unprotected_public = [
            item for item in result["public_hosts"]
            if not item["robots_blocked"] and not item["noindex"]
        ]
        if unprotected_public:
            hosts = ", ".join(item["host"] for item in unprotected_public)
            result["status"] = "warn"
            result["detail"] = (
                f"Public staging/test subdomain detected but production similarity is unconfirmed: {hosts}. "
                "Add authentication or explicit noindex/robots blocking if this is not a production site."
            )
        elif result["protected_hosts"]:
            hosts = ", ".join(sorted(set(result["protected_hosts"])))
            result["detail"] = f"Staging/test subdomain protected from indexing: {hosts}."

    return result


def normalize_origin(url: str) -> str:
    """Extract the origin (scheme + host) from a URL for constructing robots.txt and sitemap paths."""
    if not url.startswith(("http://", "https://")):
        url = f"https://{url}"
    parsed = urlparse(url)
    return f"{parsed.scheme}://{parsed.netloc}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Run site-level SEO checks (robots.txt + sitemap.xml) and output JSON."
    )
    parser.add_argument("url", help="Target URL or domain (e.g. https://example.com)")
    parser.add_argument("--timeout", "-t", type=int, default=15, help="Request timeout in seconds")
    args = parser.parse_args()

    origin = normalize_origin(args.url)

    staging_result = check_staging_subdomains(origin, args.timeout)
    robots_result = check_robots(origin, args.timeout)
    sitemap_urls = robots_result.get("sitemap_directives", [])
    sitemap_result = check_sitemap(origin, args.timeout, sitemap_urls=sitemap_urls)
    sitemap_inventory = build_sitemap_inventory(sitemap_result)

    output = {
        "origin": origin,
        "staging_subdomains": staging_result,
        "robots": robots_result,
        "sitemap": sitemap_result,
        "sitemap_inventory": sitemap_inventory,
    }

    print(json.dumps(output, indent=2, ensure_ascii=False))

    # Exit with code 1 if any check is fail or error — useful for CI integration
    has_failure = any(
        r["status"] in ("fail", "error")
        for r in [staging_result, robots_result, sitemap_result]
    )
    sys.exit(1 if has_failure else 0)


if __name__ == "__main__":
    main()
