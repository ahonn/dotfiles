---
name: seo-audit-full
description: >-
  Advanced full SEO audit skill. Runs its own full workflow from local scripts,
  including the basic SEO checks plus PageSpeed, social metadata, and advanced
  review modules when available.
metadata:
  author: Jeff
  version: "2.1"
---

# seo-audit-full — Advanced Full SEO Audit

This skill runs a full single-page SEO audit from the `seo-audit-full` directory.
It does not route to `seo-audit` when only a URL is provided.

---

## When to Use This Skill

Use `seo-audit-full` when the user asks for:

- "seo-audit-full"
- "full SEO audit"
- "advanced SEO audit"
- "technical SEO audit"
- "deep audit"
- "comprehensive SEO review"
- "audit everything"

URL-only requests are valid. When external datasets are not supplied, run the
full public-signal workflow and clearly note missing data sources in the report.

---

## Input Expected

| Input | Required | Notes |
|-------|----------|-------|
| Page URL | Yes | The primary page to audit |
| Primary keyword | Recommended | Improves content relevance scoring |
| PageSpeed API key | Yes | Required for full audit PageSpeed checks. Ask at the start and do not run PageSpeed without it. |
| Raw HTML or page content | Optional | Enables more accurate content checks when supplied |
| GSC / crawl / analytics data | Optional | Include when supplied, otherwise mark unavailable |
| Competitor benchmark data | Optional | Include when supplied |

At the start of a full audit, ask the user for a PageSpeed Insights API key:

```
For PageSpeed checks, please provide a Google PageSpeed Insights API key.
Get one here: https://developers.google.com/speed/docs/insights/v5/get-started
Open "Acquiring and using an API key" → "Get a Key".
If you do not provide one, I will stop before running the full audit because
PageSpeed is a required full-audit module.
```

Do not run `seo-audit-full` PageSpeed checks without a PageSpeed API key supplied
by `--api-key`, `PAGESPEED_API_KEY`, or `GOOGLE_PAGESPEED_API_KEY`. If the key is
missing, stop and ask the user to configure it instead of rendering a full report
with missing PageSpeed data.

---

## Architecture: Full = Core + Performance + Advanced

```
┌─────────────────────────────────────────────────────────────┐
│  seo-audit-full Workflow                                    │
│                                                             │
│  Phase 1: Run core scripts (./scripts/)                     │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  check-site.py      → robots.txt, sitemap, 404, URL  │   │
│  │  check-page.py      → title, H1, meta desc, slug     │   │
│  │  check-schema.py    → JSON-LD validation              │   │
│  │  fetch-page.py      → raw HTML for analysis           │   │
│  └──────────────────────────────────────────────────────┘   │
│                          ↓                                  │
│  Phase 2: Run performance + full-only scripts (./scripts/)  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  check-pagespeed.py → Lighthouse scores + metrics     │   │
│  │  check-social.py    → OG Tags + Twitter Card          │   │
│  │  (more scripts added here as modules grow)            │   │
│  └──────────────────────────────────────────────────────┘   │
│                          ↓                                  │
│  Phase 3: LLM-only advanced checks                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  E-E-A-T content quality scoring                      │   │
│  │  Duplicate content signals                            │   │
│  │  Anchor text quality assessment                       │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Output

Produce an **Advanced Full SEO Audit Report** by filling the template at
[assets/report-template.html](assets/report-template.html),
then **save it to a file — never print raw HTML to the terminal**.

**File naming:** `reports/<hostname>-<slug>-full-audit.html`
```
https://example.com/blog/best-tools → reports/example-com-blog-best-tools-full-audit.html
https://example.com/                → reports/example-com-full-audit.html
```

**After saving, tell the user:**
```
✅ Full Report saved → reports/example-com-full-audit.html
   Open it now? (yes / no)
```
If yes → run: `open reports/example-com-full-audit.html`

**Template placeholders** — fill each independently:

| Placeholder | Content |
|---|---|
| `{{summary_verdict}}` | One sentence: total checks run, how many failed/warned/passed |
| `{{summary_critical_html}}` | `<li>` per critical item, or `<li class="summary-empty">None</li>` |
| `{{summary_warnings_html}}` | `<li>` per warning item, or `<li class="summary-empty">None</li>` |
| `{{summary_passing_html}}` | `<li>` per passing check, or `<li class="summary-empty">None</li>` |
| `{{pagespeed_checks_html}}` | Full PageSpeed module using `check-pagespeed.py` output |
| `{{site_checks_html}}` | Site-level check tables |
| `{{eeat_checks_html}}` | E-E-A-T trust page table |
| `{{page_checks_html}}` | Page-level check tables, including full-only additions |
| `{{priority_actions_html}}` | Ordered priority action list |
| `{{insights_html}}` | Optional finding walkthrough cards |

---

## Scripts

Run full scripts from this directory. All output is structured JSON — use it
directly as evidence.

**Dependencies:** `pip install requests`

### Phase 1: Core scripts

```bash
# 1. site-level checks (robots.txt + sitemap.xml + 404 + URL canonicalization)
python scripts/check-site.py https://example.com

# 2. page-level checks (H1, title, meta description, canonical, URL slug)
python scripts/check-page.py https://example.com --keyword "primary keyword"

# 3. fetch raw HTML for downstream scripts
python scripts/fetch-page.py https://example.com --output /tmp/page.html

# 4. JSON-LD schema validation
python scripts/check-schema.py --file /tmp/page.html
```

### Phase 2: Full-only scripts

```bash
# 5. PageSpeed / Lighthouse checks
python scripts/check-pagespeed.py https://example.com --strategy mobile --timeout 180 --api-key "USER_PROVIDED_KEY"
# If no key was provided, do not run this command. Ask the user to configure a PageSpeed API key first.

# 6. Social tags: OG + Twitter Card validation
python scripts/check-social.py --file /tmp/page.html
# Or directly from URL:
python scripts/check-social.py https://example.com
```

Each script exits with code `0` (all pass/warn) or `1` (any fail/error).

PageSpeed can take 200 seconds. Use a 180-second timeout by default. If it
still times out, mark the Page Speed module as `error` and state that the
PageSpeed API timed out; do not treat that as confirmed page performance failure.
If PageSpeed fails because Google returns a quota/API-key error after a key was
provided, keep the audit running and render the PageSpeed module as `error` with
this instruction:
`Get a PageSpeed API key at https://developers.google.com/speed/docs/insights/v5/get-started → "Acquiring and using an API key" → "Get a Key".`

---

## Scope — Full Audit Check Whitelist

Full runs its own core checks plus the full-only items marked ★ below.

### Site-Level Checks (in `{{site_checks_html}}`)

Core checks:
- Sitemap URL Inventory · Staging Subdomain Indexation · robots.txt · sitemap.xml · 404 Handling · URL Canonicalization · i18n / hreflang

**Staging Subdomain Indexation rules:**
- Check common staging/test hosts before robots.txt: `test.`, `staging.`, `dev.`, `preview.`, `beta.`, `uat.`
- **Fail** when a staging/test subdomain is publicly accessible, closely mirrors the production site, and is not protected by authentication, `noindex`, or a blocking `robots.txt`.
- **Warn** when a staging/test subdomain is publicly accessible but similarity or index protection cannot be confirmed.
- **Pass** when no public staging/test subdomain is detected, or detected staging hosts are protected by authentication, non-200 access, `noindex`, or `Disallow: /`.
- Explain the impact as duplicate indexable pages: Google may treat `test.example.com` and `www.example.com` as separate but near-identical URLs, splitting ranking signals and competing with the production site.
- Recommended fixes: add Basic Auth/password protection first; also block crawlers on the staging host with `User-agent: *` + `Disallow: /`; add page-level `noindex` if pages can still be accessed.

**Sitemap URL Inventory rules:**
- Place this as the first module in `{{site_checks_html}}`, before the Crawlability table.
- Render it as its own table with columns: Directory · URL Count · Page Type · Example Page.
- Use `check-site.py` `sitemap_inventory` output to summarize first-level directories, URL counts, inferred page types, and one representative example URL.
- Treat this as a site-level map, not a pass/fail single-page SEO audit.
- Use status `info` unless sitemap URLs cannot be parsed; do not penalize a site for having many or few URLs in a directory without deeper evidence.
- Always include a next-step note: the user can continue with deeper full audits by selecting representative sample URLs from major directories such as `/blog/`, `/tools/`, `/alternatives/`, `/templates/`, or `/use-cases/`.

### Page Speed Checks (in `{{pagespeed_checks_html}}`)

Full-only:
- Lighthouse category scores: Performance · Accessibility · Best Practices · SEO
- Lab metrics: FCP · LCP · TBT · CLS · Speed Index
- Final URL and screenshot availability

### E-E-A-T Checks (in `{{eeat_checks_html}}`)

Core checks:
- About Us · Contact · Privacy Policy · Terms of Service · Media/Partners (only if present)

Contact logic (Contact row only):
- A dedicated `/contact` page is **not required**
- **Pass** if contact is reachable via any of: dedicated contact page (HTTP 200) · About page with contact details · footer/nav mailto, email, social links, or contact form
- **Fail** only when no contact pathway exists anywhere on the site
- Missing `/contact` alone is **not** a fail when About or footer/nav already expose contact info

E-E-A-T infrastructure rules — two layers per trust page:
- **Layer 1 — Exists:** HTTP 200 for the trust page URL (Contact uses Contact-specific rules above)
- **Layer 2 — Reachable:** linked from footer or main nav

| Page | Required |
|---|---|
| About Us | Yes |
| Contact | Yes — dedicated page optional; About or footer/nav contact details satisfy this |
| Privacy Policy | Yes |
| Terms of Service | Yes |
| Media / Partners | No — include only if present |

Status rules (About, Privacy, Terms, Media/Partners):
- Page missing (non-200) → **Fail**
- Page exists but not linked in footer/nav → **Warn**
- Page exists and linked in footer/nav → **Pass**
- Optional page missing → skip, do not include row

**Contact-specific rules:**
1. Try common paths (`/contact`, `/contact-us`) — HTTP 200 counts as Exists
2. If no contact page, check the About page body for email, social, or contact details
3. Also scan homepage footer and nav for `mailto:`, visible email, social links, or a contact form
4. **Exists Pass** if any contact pathway is found
5. **Exists Fail** only when no contact information is found anywhere
6. **Reachable Pass** if a contact page link or contact details appear in footer/nav
7. **Reachable Warn** if contact is only reachable inside About page content, not directly in footer/nav
8. Do not recommend creating `/contact` when About or footer already expose contact info

### Page-Level Checks (in `{{page_checks_html}}`), output in this exact order:

Core checks:
URL Slug · Title Tag · Meta Description · H1 Tag · Canonical Tag · Image Alt Text ·
Word Count · Keyword Placement · Heading Structure · Internal Links · Schema (JSON-LD)

**Schema (JSON-LD) rules:**
- Treat Schema as a quality check, not only a presence check.
- Validate JSON-LD parseability, expected `@type`, required fields, recommended rich-result fields, nested fields, and primary-type conflicts.
- **Fail** when JSON-LD is invalid, the expected schema type is missing, required fields are missing, or localized schema clearly points to the wrong language/URL.
- **Warn** when recommended fields are missing, nested fields are incomplete, multilingual pages lack `inLanguage`, or localized schema cannot be fully confirmed.
- **Pass** only when the expected schema type is present, required fields are present, no conflicts are found, and localized schema matches the current page language/URL when applicable.
- For multilingual pages, each language version should have its own schema with matching `inLanguage`, language-specific headline/description where present, and `url` / `mainEntityOfPage` pointing to the current localized canonical URL.

★ Full-only additions:
- **OG Tags** — og:title, og:description, og:image, og:type, og:url presence and validity
- **Twitter Card** — twitter:card type, title/description/image (with OG fallback detection)

---

## How to Use Script JSON Output

Same rules across full audit modules — map each field's `status` directly to the report check table:
- `status` → `pass` / `warn` / `fail` / `error` → badge in report
- `detail` → starting point for Evidence line
- Do not contradict script output unless you have additional observable evidence

**For `check-site.py` output:**
- `staging_subdomains.status` → Staging Subdomain Indexation row status
- `staging_subdomains.detail` → Staging Subdomain Indexation row detail
- `staging_subdomains.public_hosts` → evidence for public staging/test hosts
- `staging_subdomains.similar_hosts` → fail evidence for production-like staging duplicates
- `robots.status` → robots.txt row status
- `sitemap.status` → sitemap.xml row status
- `sitemap_inventory.status` → Sitemap URL Inventory module status
- `sitemap_inventory.directories[]` → table rows with `path`, `url_count`, `page_type`, and `example_url`
- `sitemap_inventory.detail` → short explanatory note below the inventory table

**For `check-schema.py` output:**
- `status` → Schema (JSON-LD) row status
- `detail` → Schema (JSON-LD) row detail
- `parse_errors` → fail evidence for malformed JSON-LD
- `schemas[].fields_missing` → fail evidence for missing required schema fields
- `schemas[].recommended_missing` and `schemas[].nested_issues` → warning evidence
- `localized_schema.status` → language/URL alignment status for multilingual schema
- `localized_schema.issues` → evidence for schema language or URL mismatch

**For `check-social.py` output:**
- `og.status` → OG Tags row status
- `twitter_card.status` → Twitter Card row status
- `og.fields.*` → individual field details for the detail cell
- `twitter_card.fields.*` → individual field details, note fallback fields

**For `check-pagespeed.py` output:**
- `status` → overall Page Speed status
- `category_status` → Lighthouse Scores badge status
- `metric_status` → Core Lab Metrics badge status
- `final_url` → Final URL line
- `categories.performance.score` → Performance score
- `categories.accessibility.score` → Accessibility score
- `categories["best-practices"].score` → Best Practices score
- `categories.seo.score` → SEO score
- `compact_metrics.fcp.display_value` → FCP
- `compact_metrics.lcp.display_value` → LCP
- `compact_metrics.tbt.display_value` → TBT
- `compact_metrics.cls.display_value` → CLS
- `compact_metrics.si.display_value` → Speed Index
- `screenshot` truthy → Screenshot available

Do not use overall `status` for the Lighthouse Scores badge. Category scores use
Lighthouse thresholds: 90–100 pass, 50–89 warn, 0–49 fail. Example: Performance
60, Accessibility 84, Best Practices 100, SEO 100 means `category_status` is
`warn`. If LCP or Speed Index fails, `metric_status` and overall `status` may be
`fail` while the Lighthouse Scores panel remains `warn`.

Inside `{{pagespeed_checks_html}}`, include a short `Priority Actions` list after
the score/metric cards. Keep it to 2–4 concise items based on failing or warning
PageSpeed fields:
- LCP slow → optimize hero media, preload critical image, reduce render-blocking CSS
- Speed Index slow → defer non-critical scripts and reduce above-the-fold JS/CSS
- TBT high → split long tasks and delay third-party tags
- Performance score warning/fail → prioritize the biggest Lighthouse opportunities

Always include the official diagnostic link:
`https://pagespeed.web.dev/`

---

## LLM Review Instructions

### Core LLM reviews

Resolve every `llm_review_required: true` field before writing the report:
H1 semantic judgment, Title keyword position, URL Slug evaluation, and Meta
Description quality must all receive an explicit judgment.

### Full-only LLM checks

**OG Tags quality (always review):**
```
og:title   : Does it differ meaningfully from <title>? It should be optimized for social sharing.
og:description : Is it compelling for social feeds? Different focus than meta description is OK.
og:image   : Is the URL an actual image path (not a page URL)?
```

**Twitter Card completeness:**
```
If twitter:card is "summary_large_image", twitter:image (or og:image fallback) must be
at least 300x157px. Flag if the image URL looks like a small icon or favicon.
```

---

## Recommended Workflow

1. **Acknowledge full scope** — confirm this is a full audit
2. **Infer primary keyword** — read the page H1, title, and first paragraph unless the user provided one
3. **Phase 1: Run core scripts** — check-site → check-page → fetch-page → check-schema
4. **Phase 2: Run full-only scripts** — verify PageSpeed API key exists, then run check-pagespeed → check-social
5. **Core checks** — 404 handling, URL canonicalization, E-E-A-T trust pages, i18n/hreflang
6. **PageSpeed checks** — summarize Lighthouse category scores and lab metrics
7. **LLM-only advanced checks** — E-E-A-T content quality, duplicate content signals, anchor text quality
8. **Summarize findings** — Evidence / Impact / Fix format
9. **Priority actions** — top 5 highest-impact fixes with effort/impact tags
10. **Render report** — save to `reports/<hostname>-<slug>-full-audit.html`

---

## Report Detail Writing Rules

Use strict formatting:

**Pass → one short phrase. No lists, no elaboration.**

**Warn → one `<div class="detail-issue">` with ≤2 bullet points. One `<div class="detail-fix">`.**

**Fail → same as Warn. Lead with the exact failure.**

---

## Mandatory Finding Format

```
**Finding: [Finding Title]**

- **Evidence:** [Observable fact, data point, or marked assumption]
- **Impact:** [SEO / UX consequence]
- **Fix:** [Actionable recommendation with example]
```

For Priority Actions, add effort/impact tags:
```
1. [High Impact / Low Effort] Fix og:image — social shares currently show no preview.
```

---

## Reference Files

- Detailed audit modules and field definitions: [references/REFERENCE.md](references/REFERENCE.md)
- Final HTML report template: [assets/report-template.html](assets/report-template.html)
- PageSpeed validation script: [scripts/check-pagespeed.py](scripts/check-pagespeed.py)
- Social tags validation script: [scripts/check-social.py](scripts/check-social.py)
- Core scripts: [scripts/](scripts/) (check-site, check-page, check-schema, fetch-page)
