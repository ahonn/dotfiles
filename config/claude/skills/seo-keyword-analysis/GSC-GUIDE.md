# Google Search Console Integration Guide

Reference for using GSC MCP tools in keyword analysis.

## Available Tools

### 1. `mcp__gsc__list_sites`

List all sites connected to GSC.

**Use Case**: First step to identify available sites.

**Parameters**: None

**Output**: List of site URLs in format `sc-domain:example.com` or `https://example.com/`

---

### 2. `mcp__gsc__search_analytics`

Get search performance data.

**Use Cases**:
- Pull keyword rankings and traffic
- Analyze page performance
- Compare time periods

**Key Parameters**:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `siteUrl` | Yes | Site URL from list_sites |
| `startDate` | Yes | YYYY-MM-DD format |
| `endDate` | Yes | YYYY-MM-DD format |
| `dimensions` | No | query, page, country, device |
| `queryFilter` | No | Filter by specific keyword |
| `pageFilter` | No | Filter by specific URL |
| `filterOperator` | No | equals, contains, includingRegex |
| `rowLimit` | No | Max 25,000 |

**Common Queries**:

```yaml
# All keywords for a site (last 30 days)
siteUrl: "sc-domain:example.com"
startDate: "2025-12-15"
endDate: "2026-01-14"
dimensions: "query"
rowLimit: 1000

# Keywords for specific page
siteUrl: "sc-domain:example.com"
startDate: "2025-12-15"
endDate: "2026-01-14"
dimensions: "query"
pageFilter: "https://example.com/target-page/"

# Specific keyword performance
siteUrl: "sc-domain:example.com"
startDate: "2025-12-15"
endDate: "2026-01-14"
dimensions: "query,page"
queryFilter: "target keyword"
filterOperator: "contains"
```

---

### 3. `mcp__gsc__enhanced_search_analytics`

Enhanced version with quick wins detection.

**Additional Features**:
- Up to 25,000 rows
- Regex filters
- Built-in quick wins detection

**Extra Parameters**:

| Parameter | Description |
|-----------|-------------|
| `enableQuickWins` | Boolean, enables detection |
| `quickWinsThresholds` | Custom thresholds object |
| `regexFilter` | Advanced pattern matching |

**Quick Wins Thresholds**:

```yaml
quickWinsThresholds:
  positionRangeMin: 4      # Min position (default: 4)
  positionRangeMax: 10     # Max position (default: 10)
  minImpressions: 50       # Min impressions (default: 50)
  maxCtr: 2                # Max CTR % (default: 2)
```

---

### 4. `mcp__gsc__detect_quick_wins`

Dedicated quick wins detection.

**Use Case**: Find optimization opportunities with minimal effort.

**Parameters**:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `siteUrl` | Required | Site URL |
| `startDate` | Required | Start date |
| `endDate` | Required | End date |
| `positionRangeMin` | 4 | Min position |
| `positionRangeMax` | 10 | Max position |
| `minImpressions` | 50 | Min impressions |
| `maxCtr` | 2 | Max CTR % |
| `estimatedClickValue` | 1 | Value per click for ROI |
| `conversionRate` | 0.03 | Est. conversion rate |

**Output Includes**:
- List of quick win keywords
- Current metrics (position, impressions, CTR)
- Estimated traffic gain
- ROI calculation

---

### 5. `mcp__gsc__index_inspect`

Check if URL is indexed.

**Use Case**: Verify page visibility in Google.

**Parameters**:

| Parameter | Description |
|-----------|-------------|
| `siteUrl` | Site URL |
| `inspectionUrl` | Full URL to inspect |
| `languageCode` | e.g., "en-US" |

**Output**:
- Index status
- Crawl info
- Mobile usability
- Rich results eligibility

---

## Common Analysis Workflows

### Workflow 1: Site Overview

```
1. list_sites → Get available sites
2. search_analytics → Pull all keywords (30 days)
   - dimensions: "query"
   - rowLimit: 1000
3. Analyze: Top keywords by clicks, impressions
```

### Workflow 2: Keyword Deep Dive

```
1. search_analytics → Filter specific keyword
   - queryFilter: "target keyword"
   - filterOperator: "contains"
   - dimensions: "query,page"
2. Analyze: Which pages rank, positions, CTR
3. Compare: vs competitors in SERP
```

### Workflow 3: Quick Wins Hunt

```
1. detect_quick_wins → Get opportunities
   - positionRangeMin: 4
   - positionRangeMax: 20
   - minImpressions: 100
   - maxCtr: 3
2. Prioritize: By impressions (traffic potential)
3. Action: Optimize titles, meta descriptions, content
```

### Workflow 4: Page Performance

```
1. search_analytics → Filter by page
   - pageFilter: "https://example.com/page/"
   - dimensions: "query"
2. Analyze: Which keywords drive traffic
3. Identify: Missing keywords to add
```

### Workflow 5: Trend Analysis

```
1. search_analytics → Current period (30 days)
2. search_analytics → Previous period (30 days before)
3. Compare: Position changes, traffic changes
4. Identify: Rising/falling keywords
```

---

## Metrics Interpretation

### Position

| Range | Meaning | Action |
|-------|---------|--------|
| 1-3 | Dominant | Maintain, expand to related |
| 4-10 | Page 1 | Quick win potential |
| 11-20 | Page 2 | Content improvement needed |
| 20+ | Low visibility | Major overhaul or new content |

### CTR Benchmarks (by Position)

| Position | Expected CTR | Below = Opportunity |
|----------|--------------|---------------------|
| 1 | 25-35% | <20% |
| 2 | 12-18% | <10% |
| 3 | 8-12% | <6% |
| 4-5 | 5-8% | <4% |
| 6-10 | 2-5% | <2% |

### Impressions

| Volume | Classification |
|--------|---------------|
| 10,000+ | High volume keyword |
| 1,000-10,000 | Medium volume |
| 100-1,000 | Long-tail |
| <100 | Very long-tail / niche |

---

## Date Range Strategies

| Purpose | Range | Why |
|---------|-------|-----|
| Quick check | 7 days | Recent snapshot |
| Standard analysis | 28-30 days | Full month cycle |
| Trend analysis | 90 days | Seasonal patterns |
| YoY comparison | 365 days | Annual trends |

**Note**: GSC data has 2-3 day lag. Most recent data may be incomplete.

---

## Filtering Tips

### Query Filters

```yaml
# Exact match
queryFilter: "ai headshot generator"
filterOperator: "equals"

# Contains
queryFilter: "headshot"
filterOperator: "contains"

# Regex (branded queries)
regexFilter: "^(headshot pro|headshotpro)"
filterOperator: "includingRegex"

# Exclude branded
regexFilter: "^(?!.*brand).*"
filterOperator: "includingRegex"
```

### Page Filters

```yaml
# Specific page
pageFilter: "https://example.com/tool/"
filterOperator: "equals"

# Section of site
pageFilter: "/blog/"
filterOperator: "contains"
```

---

## Limitations

- **Data lag**: 2-3 days delay
- **Sampling**: Large sites may have sampled data
- **Anonymous queries**: Some queries hidden for privacy
- **Position averaging**: Position is average, not current
- **No competitor data**: Only your own site's performance
