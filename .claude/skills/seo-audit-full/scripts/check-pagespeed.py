#!/usr/bin/env python3
"""
PageSpeed Insights / Lighthouse checks.

Fetches PageSpeed Insights metrics for a target URL and outputs structured JSON
for direct use in seo-audit-full reports.

Usage:
    python scripts/check-pagespeed.py https://example.com
    python scripts/check-pagespeed.py https://example.com --strategy desktop
    python scripts/check-pagespeed.py https://example.com --category performance --category seo
    python scripts/check-pagespeed.py https://example.com --api-key "$PAGESPEED_API_KEY"

Output: JSON — Lighthouse category scores + FCP/LCP/TBT/CLS/Speed Index.

Dependencies:
    pip install requests
"""

import argparse
import ipaddress
import json
import os
import re
import socket
import sys
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


API_URL = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed"
_DEFAULT_TIMEOUT = 180
_GET_API_KEY_URL = "https://developers.google.com/speed/docs/insights/v5/get-started"

_VALID_STRATEGIES = frozenset({"mobile", "desktop"})
_VALID_CATEGORIES = frozenset({
    "performance",
    "accessibility",
    "best-practices",
    "seo",
})
_DEFAULT_CATEGORIES = [
    "performance",
    "accessibility",
    "best-practices",
    "seo",
]

# Lighthouse thresholds.
# Values are milliseconds except CLS, which is unitless.
_THRESHOLDS = {
    "first-contentful-paint": {"pass": 1800, "warn": 3000, "unit": "ms"},
    "largest-contentful-paint": {"pass": 2500, "warn": 4000, "unit": "ms"},
    "total-blocking-time": {"pass": 200, "warn": 600, "unit": "ms"},
    "cumulative-layout-shift": {"pass": 0.1, "warn": 0.25, "unit": "unitless"},
    "speed-index": {"pass": 3400, "warn": 5800, "unit": "ms"},
}

_METRIC_NAMES = {
    "first-contentful-paint": "First Contentful Paint",
    "largest-contentful-paint": "Largest Contentful Paint",
    "total-blocking-time": "Total Blocking Time",
    "cumulative-layout-shift": "Cumulative Layout Shift",
    "speed-index": "Speed Index",
}

_METRIC_ALIASES = {
    "first-contentful-paint": "fcp",
    "largest-contentful-paint": "lcp",
    "total-blocking-time": "tbt",
    "cumulative-layout-shift": "cls",
    "speed-index": "si",
}

_FAKE_IP_NETWORKS = (
    ipaddress.ip_network("198.18.0.0/15"),
)


def _is_blocked_ip(ip_text: str) -> bool:
    """Return True for private, local, reserved, multicast, or unspecified IPs."""
    ip = ipaddress.ip_address(ip_text)
    return any((
        ip.is_private,
        ip.is_loopback,
        ip.is_link_local,
        ip.is_reserved,
        ip.is_multicast,
        ip.is_unspecified,
    ))


def _is_proxy_fake_ip(ip_text: str) -> bool:
    """Return True for common local proxy fake-IP DNS ranges."""
    ip = ipaddress.ip_address(ip_text)
    return any(ip in network for network in _FAKE_IP_NETWORKS)


def _resolve_with_google_dns(host: str, timeout: int = 5) -> list[str]:
    """Resolve public A/AAAA records through Google DNS-over-HTTPS."""
    ips: set[str] = set()
    for record_type in ("A", "AAAA"):
        try:
            response = requests.get(
                "https://dns.google/resolve",
                params={"name": host, "type": record_type},
                timeout=timeout,
            )
            response.raise_for_status()
            data = response.json()
        except (requests.exceptions.RequestException, ValueError):
            continue

        for answer in data.get("Answer", []):
            value = answer.get("data")
            if not value:
                continue
            try:
                ipaddress.ip_address(value)
            except ValueError:
                continue
            ips.add(value)
    return sorted(ips)


def _normalize_url(url: str) -> str:
    """Add https:// when the user provides a bare domain."""
    if url.startswith(("http://", "https://")):
        return url
    return f"https://{url}"


def _redact_api_key(text: str) -> str:
    """Remove API key values from error strings before JSON output."""
    return re.sub(r"([?&]key=)[^&\s]+", r"\1[REDACTED_API_KEY]", text)


def validate_public_url(raw_url: str) -> str:
    """
    Normalize and validate a URL before sending it to PageSpeed.

    This script is intended to model a backend proxy. It rejects localhost,
    .local hostnames, direct private IPs, and DNS names that resolve to private
    or otherwise non-public addresses.
    """
    url = _normalize_url(raw_url.strip())
    parsed = urlparse(url)

    if parsed.scheme not in {"http", "https"}:
        raise ValueError("Invalid protocol. Use http or https.")
    if not parsed.hostname:
        raise ValueError("URL hostname is required.")
    if parsed.username or parsed.password:
        raise ValueError("Credentials in URL are not allowed.")

    host = parsed.hostname.lower().rstrip(".")
    if host == "localhost" or host.endswith(".local"):
        raise ValueError("Private URL not allowed.")

    try:
        if _is_blocked_ip(host):
            raise ValueError("Private IP URL not allowed.")
    except ValueError as exc:
        if "Private IP URL" in str(exc):
            raise

    try:
        addr_infos = socket.getaddrinfo(host, None, proto=socket.IPPROTO_TCP)
    except socket.gaierror as exc:
        raise ValueError(f"DNS resolution failed: {exc}") from exc

    resolved_ips = sorted({info[4][0] for info in addr_infos})
    blocked = [ip for ip in resolved_ips if _is_blocked_ip(ip)]
    if blocked and all(_is_proxy_fake_ip(ip) for ip in blocked):
        doh_ips = _resolve_with_google_dns(host)
        if doh_ips:
            resolved_ips = doh_ips
            blocked = [ip for ip in resolved_ips if _is_blocked_ip(ip)]

    if blocked:
        raise ValueError(f"Private URL not allowed: resolves to {blocked[0]}")

    return url


def _score_status(score: Optional[float]) -> str:
    """Map Lighthouse performance score to pass/warn/fail/error."""
    if score is None:
        return "error"
    if score >= 90:
        return "pass"
    if score >= 50:
        return "warn"
    return "fail"


def _category_score(category: Optional[dict]) -> Optional[float]:
    """Return a 0-100 category score, or None when unavailable."""
    if not category:
        return None
    score = category.get("score")
    return round(score * 100) if isinstance(score, (int, float)) else None


def _metric_status(metric_id: str, numeric_value: Optional[float]) -> str:
    """Map a Lighthouse metric value to pass/warn/fail/error."""
    if numeric_value is None:
        return "error"

    thresholds = _THRESHOLDS.get(metric_id)
    if not thresholds:
        return "error"

    if numeric_value <= thresholds["pass"]:
        return "pass"
    if numeric_value <= thresholds["warn"]:
        return "warn"
    return "fail"


def _metric_detail(metric_id: str, display_value: str, status: str) -> str:
    """Build a concise report-ready detail string."""
    thresholds = _THRESHOLDS.get(metric_id, {})
    name = _METRIC_NAMES.get(metric_id, metric_id)

    if status == "error":
        return f"{name}: unavailable."

    pass_threshold = thresholds.get("pass")
    warn_threshold = thresholds.get("warn")
    unit = thresholds.get("unit", "")
    if unit == "ms":
        return (
            f"{name}: {display_value} · pass ≤ {pass_threshold / 1000:g}s · "
            f"warning ≤ {warn_threshold / 1000:g}s."
        )
    if unit == "unitless":
        return (
            f"{name}: {display_value} · pass ≤ {pass_threshold:g} · "
            f"warning ≤ {warn_threshold:g}."
        )
    return f"{name}: {display_value}."


def _extract_metric(audits: dict, metric_id: str) -> dict:
    """Extract one Lighthouse metric with normalized status/detail fields."""
    audit = audits.get(metric_id, {})
    numeric_value = audit.get("numericValue")
    if isinstance(numeric_value, (int, float)):
        numeric_value = float(numeric_value)
    else:
        numeric_value = None

    display_value = audit.get("displayValue") or "N/A"
    status = _metric_status(metric_id, numeric_value)

    return {
        "id": metric_id,
        "key": _METRIC_ALIASES.get(metric_id, metric_id),
        "title": audit.get("title") or _METRIC_NAMES.get(metric_id, metric_id),
        "status": status,
        "display_value": display_value,
        "numeric_value": numeric_value,
        "numeric_unit": audit.get("numericUnit"),
        "score": audit.get("score"),
        "thresholds": _THRESHOLDS.get(metric_id, {}),
        "detail": _metric_detail(metric_id, display_value, status),
    }


def _pick_audit(audits: dict, audit_id: str) -> Optional[dict]:
    """Return a compact audit value object for frontend/plugin consumers."""
    audit = audits.get(audit_id)
    if not audit:
        return None
    return {
        "value": audit.get("numericValue"),
        "display_value": audit.get("displayValue"),
        "score": audit.get("score"),
    }


def _extract_categories(categories: dict, requested_categories: list[str]) -> dict:
    """Extract normalized Lighthouse category score objects."""
    result = {}
    for category_id in requested_categories:
        category = categories.get(category_id)
        score = _category_score(category)
        result[category_id] = {
            "status": _score_status(score),
            "score": score,
            "title": category.get("title") if category else category_id,
        }
    return result


def _extract_field_data(experience: Optional[dict]) -> Optional[dict]:
    """Return compact CrUX field data if PSI includes it."""
    if not experience:
        return None
    metrics = {}
    for metric_id, metric in experience.get("metrics", {}).items():
        metrics[metric_id] = {
            "category": metric.get("category"),
            "percentile": metric.get("percentile"),
            "distributions": metric.get("distributions", []),
        }
    return {
        "id": experience.get("id"),
        "overall_category": experience.get("overall_category"),
        "initial_url": experience.get("initial_url"),
        "metrics": metrics,
    }


def _overall_status(statuses: list[str]) -> str:
    """Combine check statuses using the same semantics as other audit scripts."""
    if "error" in statuses:
        return "error"
    if "fail" in statuses:
        return "fail"
    if "warn" in statuses:
        return "warn"
    return "pass"


def get_pagespeed_metrics(
    target_url: str,
    strategy: str = "mobile",
    api_key: Optional[str] = None,
    locale: str = "en",
    timeout: int = _DEFAULT_TIMEOUT,
    include_raw: bool = False,
    categories: Optional[list[str]] = None,
) -> dict:
    """Fetch PageSpeed Insights metrics for a given URL."""
    try:
        target_url = validate_public_url(target_url)
    except ValueError as exc:
        return {
            "url": _normalize_url(target_url),
            "strategy": strategy,
            "status": "error",
            "error": str(exc),
        }

    if not api_key:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": "PageSpeed API key is required for seo-audit-full.",
            "hint": (
                "Set PAGESPEED_API_KEY or GOOGLE_PAGESPEED_API_KEY, "
                "or pass --api-key. Get a key from the official PageSpeed "
                f"Get Started page: {_GET_API_KEY_URL}"
            ),
            "api_key_help_url": _GET_API_KEY_URL,
        }

    strategy = strategy.lower()
    requested_categories = categories or list(_DEFAULT_CATEGORIES)

    if strategy not in _VALID_STRATEGIES:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": "Invalid strategy. Use 'mobile' or 'desktop'.",
        }
    invalid_categories = [c for c in requested_categories if c not in _VALID_CATEGORIES]
    if invalid_categories:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": f"Invalid category: {', '.join(invalid_categories)}",
        }

    params = [
        ("url", target_url),
        ("strategy", strategy),
        ("locale", locale),
    ]
    for category in requested_categories:
        params.append(("category", category))
    if api_key:
        params.append(("key", api_key))

    try:
        response = requests.get(API_URL, params=params, timeout=timeout)
        response.raise_for_status()
        data = response.json()
    except requests.exceptions.Timeout:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": f"Timed out after {timeout}s",
        }
    except requests.exceptions.HTTPError as exc:
        error_detail = None
        try:
            error_detail = response.json().get("error", {})
        except ValueError:
            error_detail = response.text[:500]
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "http_status": response.status_code,
            "error": _redact_api_key(f"PageSpeed API HTTP error: {exc}"),
            "error_detail": error_detail,
            "hint": (
                "PageSpeed requests are quota-limited by Google. "
                "Get a PageSpeed API key from the official Get Started page, "
                "then pass it with --api-key or PAGESPEED_API_KEY. "
                f"Open {_GET_API_KEY_URL} and follow 'Acquiring and using an API key' → 'Get a Key'."
                if response.status_code in {403, 429}
                else None
            ),
            "api_key_help_url": (
                _GET_API_KEY_URL if response.status_code in {403, 429} else None
            ),
        }
    except requests.exceptions.RequestException as exc:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": _redact_api_key(f"PageSpeed API request failed: {exc}"),
        }
    except ValueError as exc:
        return {
            "url": target_url,
            "strategy": strategy,
            "status": "error",
            "error": f"Invalid JSON response: {exc}",
        }

    lighthouse = data.get("lighthouseResult", {})
    lh_categories = lighthouse.get("categories", {})
    audits = lighthouse.get("audits", {})

    score_raw = lh_categories.get("performance", {}).get("score")
    perf_score = score_raw * 100 if isinstance(score_raw, (int, float)) else None
    perf_status = _score_status(perf_score)

    metric_ids = [
        "first-contentful-paint",
        "largest-contentful-paint",
        "total-blocking-time",
        "cumulative-layout-shift",
        "speed-index",
    ]
    metrics = {metric_id: _extract_metric(audits, metric_id) for metric_id in metric_ids}
    category_results = _extract_categories(lh_categories, requested_categories)

    metric_statuses = [metric["status"] for metric in metrics.values()]
    category_statuses = [item["status"] for item in category_results.values()]
    category_status = _overall_status(category_statuses)
    metric_status = _overall_status(metric_statuses)
    status_inputs = [*category_statuses, *metric_statuses]
    if lighthouse.get("runtimeError"):
        status_inputs.append("error")
    overall = _overall_status(status_inputs)

    detail = (
        f"Performance score {perf_score:.0f}/100."
        if perf_score is not None
        else "Performance score unavailable."
    )

    result = {
        "url": target_url,
        "strategy": strategy,
        "status": overall,
        "category_status": category_status,
        "metric_status": metric_status,
        "source": "PageSpeed Insights API v5",
        "requested_categories": requested_categories,
        "performance": {
            "status": perf_status,
            "score": round(perf_score) if perf_score is not None else None,
            "detail": detail,
        },
        "categories": category_results,
        "metrics": metrics,
        "compact_metrics": {
            alias: _pick_audit(audits, metric_id)
            for metric_id, alias in _METRIC_ALIASES.items()
        },
        "screenshot": (
            audits.get("final-screenshot", {})
            .get("details", {})
            .get("data")
        ),
        "loading_experience": _extract_field_data(data.get("loadingExperience")),
        "origin_loading_experience": _extract_field_data(
            data.get("originLoadingExperience")
        ),
        "fetch_time": lighthouse.get("fetchTime"),
        "lighthouse_version": lighthouse.get("lighthouseVersion"),
        "final_url": lighthouse.get("finalUrl"),
        "requested_url": lighthouse.get("requestedUrl"),
        "runtime_error": lighthouse.get("runtimeError"),
        "detail": detail,
    }
    if include_raw:
        result["raw"] = data
    return result


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fetch PageSpeed Insights metrics and output JSON."
    )
    parser.add_argument("url", help="Target page URL")
    parser.add_argument(
        "--strategy",
        choices=sorted(_VALID_STRATEGIES),
        default="mobile",
        help="PageSpeed strategy to run. Default: mobile",
    )
    parser.add_argument(
        "--category",
        action="append",
        choices=sorted(_VALID_CATEGORIES),
        help=(
            "Lighthouse category to request. Repeat for multiple categories. "
            "Default: performance, accessibility, best-practices, seo"
        ),
    )
    parser.add_argument(
        "--api-key",
        default=(
            os.getenv("PAGESPEED_API_KEY")
            or os.getenv("GOOGLE_PAGESPEED_API_KEY")
        ),
        help="Google PageSpeed API key. Required unless PAGESPEED_API_KEY or GOOGLE_PAGESPEED_API_KEY is set.",
    )
    parser.add_argument(
        "--locale",
        default="en",
        help="Locale for PageSpeed suggestions. Default: en",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=_DEFAULT_TIMEOUT,
        help=f"Request timeout in seconds. Default: {_DEFAULT_TIMEOUT}",
    )
    parser.add_argument(
        "--include-raw",
        action="store_true",
        help="Include raw PageSpeed API response in output.",
    )
    args = parser.parse_args()

    result = get_pagespeed_metrics(
        args.url,
        strategy=args.strategy,
        api_key=args.api_key,
        locale=args.locale,
        timeout=args.timeout,
        include_raw=args.include_raw,
        categories=args.category,
    )

    print(json.dumps(result, indent=2, ensure_ascii=False))
    sys.exit(1 if result.get("status") in {"fail", "error"} else 0)


if __name__ == "__main__":
    main()
