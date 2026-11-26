#!/usr/bin/env python3
"""
JSON-LD structured data validator for SEO auditing.

Extracts <script type="application/ld+json"> blocks, validates @type and
required fields per Schema.org spec. Page type inference is heuristic —
always sets llm_review_required for agent confirmation.

Usage:
    python scripts/check-schema.py https://example.com
    python scripts/check-schema.py --file page.html

Output: JSON with found schemas, validation results, and LLM review flags.

Dependencies:
    pip install requests
"""

import argparse
import ipaddress
import json
import socket
import sys
from html.parser import HTMLParser
from typing import Optional
from urllib.parse import urlparse

try:
    import requests
except ImportError:
    print(
        "Error: requests library required. Install with: pip install requests",
        file=sys.stderr,
    )
    sys.exit(1)


_DEFAULT_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 ClaudeSEO/1.2"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Connection": "keep-alive",
}

# 各 @type 必填字段（缺失 → fail）
REQUIRED_FIELDS: dict[str, list[str]] = {
    "WebSite": ["name", "url"],
    "Organization": ["name", "url", "logo"],
    "Article": ["headline", "datePublished", "author", "image"],
    "BlogPosting": ["headline", "datePublished", "author", "image"],
    "NewsArticle": ["headline", "datePublished", "author", "image"],
    "Product": ["name", "image", "offers"],
    "FAQPage": ["mainEntity"],
    "HowTo": ["name", "step"],
    "LocalBusiness": ["name", "address", "telephone"],
}

# 推荐字段（缺失 → warn）
RECOMMENDED_FIELDS: dict[str, list[str]] = {
    "Article": ["dateModified", "publisher", "mainEntityOfPage"],
    "BlogPosting": ["dateModified", "publisher", "mainEntityOfPage"],
    "NewsArticle": ["dateModified", "publisher", "mainEntityOfPage"],
    "Product": ["aggregateRating", "brand", "description"],
    "Organization": ["sameAs", "contactPoint"],
    "WebSite": ["potentialAction"],
}

# 嵌套字段要求：父字段 → 子字段列表
NESTED_REQUIREMENTS: dict[str, dict[str, list[str]]] = {
    "Product": {"offers": ["price", "priceCurrency"]},
    "FAQPage": {"mainEntity": ["name", "acceptedAnswer"]},
    "HowTo": {"step": ["text"]},
}

# 页面类型 → 期望 @type 映射
PAGE_TYPE_EXPECTED: dict[str, list[str]] = {
    "homepage": ["WebSite", "Organization"],
    "article": ["Article", "BlogPosting", "NewsArticle"],
    "product": ["Product"],
    "faq": ["FAQPage"],
    "howto": ["HowTo"],
    "local_business": ["LocalBusiness"],
}


# ── HTTP fetch ────────────────────────────────────────────────────────────────


def _safe_fetch(
    url: str, timeout: int
) -> tuple[Optional[int], Optional[str], Optional[str]]:
    """Fetch URL with SSRF protection. Returns (status, content, error)."""
    parsed = urlparse(url)
    try:
        hostname = parsed.hostname or ""
        resolved_ip = socket.gethostbyname(hostname)
        ip = ipaddress.ip_address(resolved_ip)
        if ip.is_private or ip.is_loopback or ip.is_reserved:
            return None, None, f"Blocked: resolves to private IP ({resolved_ip})"
    except (socket.gaierror, ValueError):
        pass

    try:
        resp = requests.get(
            url, headers=_DEFAULT_HEADERS, timeout=timeout, allow_redirects=True
        )
        return resp.status_code, resp.text, None
    except requests.exceptions.RequestException as exc:
        return None, None, str(exc)


# ── HTML parser ───────────────────────────────────────────────────────────────


class _JsonLdExtractor(HTMLParser):
    """Single-pass extractor for <script type="application/ld+json"> blocks."""

    def __init__(self) -> None:
        super().__init__()
        self.blocks: list[str] = []
        self.html_lang: Optional[str] = None
        self.canonical_url: Optional[str] = None
        self.hreflang_urls: dict[str, str] = {}
        self._in_jsonld = False
        self._buf = ""

    def handle_starttag(self, tag: str, attrs: list[tuple[str, Optional[str]]]) -> None:
        attrs_dict = {k.lower(): (v or "") for k, v in attrs}
        if tag == "html":
            lang = attrs_dict.get("lang", "").strip()
            if lang:
                self.html_lang = lang
        elif tag == "link":
            rel_values = {v.lower() for v in attrs_dict.get("rel", "").split()}
            href = attrs_dict.get("href", "").strip()
            if "canonical" in rel_values and href:
                self.canonical_url = href
            if "alternate" in rel_values and href:
                hreflang = attrs_dict.get("hreflang", "").strip()
                if hreflang:
                    self.hreflang_urls[hreflang] = href

        if tag == "script":
            if attrs_dict.get("type", "").lower() == "application/ld+json":
                self._in_jsonld = True
                self._buf = ""

    def handle_endtag(self, tag: str) -> None:
        if tag == "script" and self._in_jsonld:
            self._in_jsonld = False
            content = self._buf.strip()
            if content:
                self.blocks.append(content)

    def handle_data(self, data: str) -> None:
        if self._in_jsonld:
            self._buf += data


# ── Schema helpers ────────────────────────────────────────────────────────────


def _flatten_schemas(raw_blocks: list[str]) -> tuple[list[dict], list[str]]:
    """Parse JSON-LD blocks and flatten @graph arrays into individual schemas."""
    schemas: list[dict] = []
    parse_errors: list[str] = []
    for text in raw_blocks:
        try:
            parsed = json.loads(text)
        except json.JSONDecodeError as exc:
            parse_errors.append(f"Invalid JSON-LD: {exc.msg} at line {exc.lineno}, column {exc.colno}.")
            continue

        if isinstance(parsed, list):
            schemas.extend(item for item in parsed if isinstance(item, dict))
        elif isinstance(parsed, dict):
            graph = parsed.get("@graph")
            if isinstance(graph, list):
                schemas.extend(item for item in graph if isinstance(item, dict))
            else:
                schemas.append(parsed)
    return schemas, parse_errors


def _get_types(schema: dict) -> list[str]:
    """Extract @type as a normalized list."""
    raw = schema.get("@type")
    if isinstance(raw, str):
        return [raw]
    if isinstance(raw, list):
        return [t for t in raw if isinstance(t, str)]
    return []


def _field_present(schema: dict, field: str) -> bool:
    """Check if a field exists and is non-empty."""
    value = schema.get(field)
    if value is None:
        return False
    if isinstance(value, str) and not value.strip():
        return False
    if isinstance(value, list) and len(value) == 0:
        return False
    return True


def _normalize_lang(value: Optional[str]) -> Optional[str]:
    """Normalize language strings for loose matching."""
    if not value or not isinstance(value, str):
        return None
    normalized = value.strip().lower().replace("_", "-")
    if not normalized:
        return None
    return normalized


def _lang_matches(page_lang: Optional[str], schema_lang: Optional[str]) -> bool:
    """Accept exact language-region matches and same primary language matches."""
    page = _normalize_lang(page_lang)
    schema = _normalize_lang(schema_lang)
    if not page or not schema:
        return False
    return page == schema or page.split("-")[0] == schema.split("-")[0]


def _extract_schema_url(value) -> Optional[str]:
    """Extract URL values from schema fields that may be strings or objects."""
    if isinstance(value, str):
        return value.strip() or None
    if isinstance(value, dict):
        for key in ("@id", "url", "id"):
            nested = value.get(key)
            if isinstance(nested, str) and nested.strip():
                return nested.strip()
    return None


def _urls_equivalent(a: Optional[str], b: Optional[str]) -> bool:
    """Compare URLs loosely, ignoring trailing slash differences."""
    if not a or not b:
        return False
    return a.rstrip("/") == b.rstrip("/")


def _validate_nested(schema: dict, schema_type: str) -> list[str]:
    """Validate nested field requirements, return list of missing dotted paths."""
    issues: list[str] = []
    nested_reqs = NESTED_REQUIREMENTS.get(schema_type, {})
    for parent_field, sub_fields in nested_reqs.items():
        parent = schema.get(parent_field)
        if parent is None:
            continue
        items = parent if isinstance(parent, list) else [parent]
        if not items:
            continue
        first = items[0]
        if not isinstance(first, dict):
            continue
        for sf in sub_fields:
            if not _field_present(first, sf):
                issues.append(f"{parent_field}.{sf}")
    return issues


def _validate_schema(schema: dict) -> dict:
    """Validate a single schema against required and recommended fields."""
    types = _get_types(schema)
    if not types:
        return {
            "types": [],
            "status": "warn",
            "fields_present": [],
            "fields_missing": [],
            "recommended_missing": [],
            "nested_issues": [],
            "detail": "JSON-LD block found but missing @type.",
        }

    primary = types[0]
    required = REQUIRED_FIELDS.get(primary, [])
    recommended = RECOMMENDED_FIELDS.get(primary, [])

    present = [f for f in required if _field_present(schema, f)]
    missing = [f for f in required if not _field_present(schema, f)]
    rec_missing = [f for f in recommended if not _field_present(schema, f)]
    nested = _validate_nested(schema, primary)

    if primary not in REQUIRED_FIELDS:
        return {
            "types": types,
            "status": "info",
            "fields_present": present,
            "fields_missing": missing,
            "recommended_missing": rec_missing,
            "nested_issues": nested,
            "detail": f"{primary} — no required-field ruleset defined.",
        }

    if missing:
        detail = f"{primary}: missing required: {', '.join(missing)}."
    elif rec_missing or nested:
        parts = []
        if rec_missing:
            parts.append(f"missing recommended: {', '.join(rec_missing)}")
        if nested:
            parts.append(f"incomplete nested: {', '.join(nested)}")
        detail = f"{primary}: {'; '.join(parts)}."
    else:
        detail = f"{primary}: all required fields present."

    status = "fail" if missing else ("warn" if (rec_missing or nested) else "pass")

    return {
        "types": types,
        "status": status,
        "fields_present": present,
        "fields_missing": missing,
        "recommended_missing": rec_missing,
        "nested_issues": nested,
        "detail": detail,
    }


def _validate_localized_schema(
    schemas: list[dict],
    page_lang: Optional[str],
    canonical_url: Optional[str],
    page_url: str,
    hreflang_urls: dict[str, str],
) -> dict:
    """Validate schema language and URL alignment for localized pages."""
    issues: list[str] = []
    fixes: list[str] = []
    multilingual = len([k for k in hreflang_urls if k.lower() != "x-default"]) > 1
    current_url = canonical_url or page_url

    language_schemas = []
    url_schemas = []
    for schema in schemas:
        schema_lang = schema.get("inLanguage")
        if isinstance(schema_lang, list):
            schema_lang = schema_lang[0] if schema_lang else None
        if isinstance(schema_lang, str) and schema_lang.strip():
            language_schemas.append(schema_lang.strip())

        for field in ("url", "mainEntityOfPage"):
            schema_url = _extract_schema_url(schema.get(field))
            if schema_url:
                url_schemas.append(schema_url)

    if page_lang and language_schemas:
        mismatched = [lang for lang in language_schemas if not _lang_matches(page_lang, lang)]
        if mismatched:
            issues.append(
                f"Schema inLanguage ({', '.join(mismatched)}) does not match html lang ({page_lang})."
            )
            fixes.append("Set inLanguage to the current page language.")
    elif multilingual and page_lang:
        issues.append("Multilingual page lacks schema inLanguage.")
        fixes.append("Add language-specific inLanguage to each localized JSON-LD block.")

    if current_url and url_schemas:
        mismatched_urls = [u for u in url_schemas if not _urls_equivalent(u, current_url)]
        if mismatched_urls and len(mismatched_urls) == len(url_schemas):
            issues.append(
                "Schema url/mainEntityOfPage does not point to the current localized page."
            )
            fixes.append("Set schema url and mainEntityOfPage to the current canonical URL.")
    elif multilingual and current_url:
        issues.append("Multilingual page lacks schema url/mainEntityOfPage.")
        fixes.append("Add current-language url or mainEntityOfPage to the JSON-LD block.")

    if not issues:
        detail = (
            "Localized schema matches page language."
            if page_lang or multilingual
            else "No localized schema issue detected."
        )
        return {
            "status": "pass",
            "page_language": page_lang,
            "schema_languages": language_schemas,
            "schema_urls": url_schemas,
            "multilingual": multilingual,
            "issues": [],
            "fixes": [],
            "detail": detail,
        }

    status = "fail" if any("does not match" in issue or "does not point" in issue for issue in issues) else "warn"
    return {
        "status": status,
        "page_language": page_lang,
        "schema_languages": language_schemas,
        "schema_urls": url_schemas,
        "multilingual": multilingual,
        "issues": issues,
        "fixes": fixes,
        "detail": " ".join(issues),
    }


def _infer_page_type(url: str) -> str:
    """Heuristic page type guess from URL pattern. LLM should confirm."""
    path = urlparse(url).path.lower().rstrip("/")
    if path in ("", "/"):
        return "homepage"
    if any(s in path for s in ("/blog", "/article", "/post", "/news", "/story")):
        return "article"
    if any(s in path for s in ("/product", "/item", "/shop/", "/store/")):
        return "product"
    if "/faq" in path or "/questions" in path:
        return "faq"
    if any(s in path for s in ("/how-to", "/howto", "/guide")):
        return "howto"
    return "unknown"


# ── Main check ────────────────────────────────────────────────────────────────


def check_schema(html: str, url: str = "") -> dict:
    """Extract, parse, and validate JSON-LD from HTML content."""
    extractor = _JsonLdExtractor()
    try:
        extractor.feed(html)
    except Exception:
        return {
            "url": url,
            "status": "error",
            "schemas": [],
            "detail": "Failed to parse HTML for JSON-LD extraction.",
            "llm_review_required": False,
        }

    inferred = _infer_page_type(url)
    expected = PAGE_TYPE_EXPECTED.get(inferred, [])

    if not extractor.blocks:
        if inferred == "unknown" or not expected:
            return {
                "url": url,
                "status": "info",
                "schemas": [],
                "inferred_page_type": inferred,
                "expected_types": expected,
                "detail": "No JSON-LD found. Page type unclear — may not require structured data.",
                "llm_review_required": True,
            }
        return {
            "url": url,
            "status": "fail",
            "schemas": [],
            "inferred_page_type": inferred,
            "expected_types": expected,
            "detail": (
                f"No JSON-LD found. Inferred page type: {inferred} — "
                f"expected: {', '.join(expected)}."
            ),
            "llm_review_required": True,
        }

    all_schemas, parse_errors = _flatten_schemas(extractor.blocks)
    if not all_schemas:
        status = "fail" if parse_errors else "warn"
        detail = (
            "JSON-LD script tags found but none contained valid JSON. "
            + " ".join(parse_errors[:2])
        )
        return {
            "url": url,
            "status": status,
            "schemas": [],
            "parse_errors": parse_errors,
            "detail": detail,
            "llm_review_required": False,
        }

    validated = [_validate_schema(s) for s in all_schemas]
    found_types = list({t for v in validated for t in v["types"][:1] if t})
    localized = _validate_localized_schema(
        all_schemas,
        extractor.html_lang,
        extractor.canonical_url,
        url,
        extractor.hreflang_urls,
    )

    statuses = [v["status"] for v in validated]
    if parse_errors:
        statuses.append("fail")
    if localized["status"] in ("fail", "warn"):
        statuses.append(localized["status"])
    overall = "fail" if "fail" in statuses else ("warn" if "warn" in statuses else "pass")

    has_expected = bool(expected) and any(t in found_types for t in expected)
    has_conflicts = len(found_types) > 2

    detail_parts = [f"Found {len(all_schemas)} JSON-LD block(s): {', '.join(found_types)}."]
    if parse_errors:
        detail_parts.append("Invalid JSON-LD block(s): " + " ".join(parse_errors[:2]))
    if has_conflicts:
        detail_parts.append(f"Potential type conflict: {found_types}.")
    for v in validated:
        if v["status"] in ("fail", "warn"):
            detail_parts.append(v["detail"])
    if localized["status"] in ("fail", "warn"):
        detail_parts.append(localized["detail"])

    return {
        "url": url,
        "status": overall,
        "schemas": validated,
        "parse_errors": parse_errors,
        "found_types": found_types,
        "inferred_page_type": inferred,
        "expected_types": expected,
        "has_expected_type": has_expected,
        "has_type_conflicts": has_conflicts,
        "page_language": extractor.html_lang,
        "canonical_url": extractor.canonical_url,
        "hreflang_urls": extractor.hreflang_urls,
        "localized_schema": localized,
        "detail": " ".join(detail_parts),
        "llm_review_required": True,
    }


# ── CLI entry point ──────────────────────────────────────────────────────────


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate JSON-LD structured data on a page and output JSON."
    )
    parser.add_argument("url", nargs="?", help="Target page URL")
    parser.add_argument(
        "--file", "-f", help="Local HTML file path (skip HTTP fetch)"
    )
    parser.add_argument(
        "--timeout", "-t", type=int, default=20, help="Request timeout in seconds"
    )
    args = parser.parse_args()

    if not args.url and not args.file:
        parser.error("Provide a URL or --file <path>")

    if args.file:
        try:
            with open(args.file, "r", encoding="utf-8") as f:
                html = f.read()
        except OSError as exc:
            print(json.dumps({"error": str(exc)}, indent=2))
            sys.exit(1)
        url = args.file
    else:
        url = args.url or ""
        if not url.startswith(("http://", "https://")):
            url = f"https://{url}"
        status_code, html, error = _safe_fetch(url, args.timeout)
        if error or not html:
            err_msg = error or f"HTTP {status_code}"
            print(json.dumps({"url": url, "status": "error", "error": err_msg}, indent=2))
            sys.exit(1)

    result = check_schema(html, url=url)
    print(json.dumps(result, indent=2, ensure_ascii=False))
    sys.exit(1 if result["status"] == "fail" else 0)


if __name__ == "__main__":
    main()
