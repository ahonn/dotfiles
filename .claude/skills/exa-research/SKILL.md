---
name: exa-research
description: "Web research using Exa AI search engine. Use when: user needs web search, finding articles, research papers, news, company info, or similar content. Triggers on: 'search for', 'find articles about', 'research', 'what's the latest on', 'find companies like', 'similar to [url]'."
allowed-tools:
  - Bash
  - Read
---

# Exa Research

AI-powered web search and content retrieval using Exa API.

## Scripts Location

```
./scripts/
├── exa-search    # Search the web
├── exa-contents  # Get page contents
└── exa-similar   # Find similar links
```

## Core Workflows

### 1. Basic Search

```bash
./scripts/exa-search "your query"
```

**Search Types:**
- `auto` (default) - Intelligently combines methods
- `fast` - Quick results, lowest latency
- `deep` - Comprehensive with query expansion
- `neural` - AI semantic search

**Examples:**
```bash
# Quick search
exa-search "React 19 new features"

# Deep research
exa-search "state of LLM agents 2025" --type deep --text

# News only
exa-search "OpenAI GPT-5" --category news --num 5

# Domain filtered
exa-search "machine learning tutorials" --include-domains arxiv.org,paperswithcode.com
```

### 2. Get Page Contents

```bash
./scripts/exa-contents "https://example.com" [options]
```

**Examples:**
```bash
# Get text content
exa-contents "https://blog.example.com/post" --text

# Get summary
exa-contents "https://paper.example.com" --summary

# Multiple URLs with LLM context
exa-contents "https://url1.com" "https://url2.com" --context

# Crawl subpages (for docs)
exa-contents "https://docs.example.com" --subpages 5
```

### 3. Find Similar Links

```bash
./scripts/exa-similar "https://example.com" [options]
```

**Examples:**
```bash
# Find competitors
exa-similar "https://stripe.com" --num 10

# Similar articles with content
exa-similar "https://blog.example.com/ai-post" --text

# Filter by domain
exa-similar "https://openai.com" --include-domains techcrunch.com,wired.com
```

## Common Options Reference

| Option | Scripts | Description |
|--------|---------|-------------|
| `-t, --type` | search | auto, fast, deep, neural |
| `-n, --num` | search, similar | Number of results (max 100) |
| `-c, --category` | search | company, news, pdf, github, etc. |
| `--include-domains` | search, similar | Whitelist domains |
| `--exclude-domains` | search, similar | Blacklist domains |
| `--start-date` | search | Filter by publish date |
| `--text` | all | Include full page text |
| `--context` | all | Return LLM-optimized context |
| `--summary` | contents | AI-generated summary |
| `--highlights` | contents | Extract key passages |
| `--livecrawl` | contents | never, fallback, preferred, always |

## Research Workflow Patterns

### Pattern 1: Topic Research
```bash
# 1. Broad search with deep mode
exa-search "quantum computing applications 2025" --type deep --text | jq '.results[:5]'

# 2. Get detailed content for top results
exa-contents "https://result-url.com" --summary --context
```

### Pattern 2: Competitive Analysis
```bash
# 1. Find similar companies
exa-similar "https://target-company.com" --num 10

# 2. Deep dive on specific competitor
exa-search "CompetitorName product features" --category company --text
```

### Pattern 3: News Monitoring
```bash
# Recent news only
exa-search "AI regulation" --category news --start-date "2025-01-01" --num 20
```

### Pattern 4: Technical Documentation
```bash
# Search for docs
exa-search "Next.js App Router caching" --include-domains nextjs.org,vercel.com --text

# Or crawl docs site
exa-contents "https://nextjs.org/docs/app/caching" --subpages 3 --context
```

## Response Processing Tips

```bash
# Extract URLs only
exa-search "query" | jq -r '.results[].url'

# Get titles and URLs
exa-search "query" | jq '.results[] | {title, url}'

# Extract context string for LLM
exa-search "query" --context | jq -r '.context'

# Check cost
exa-search "query" | jq '.costDollars'
```

## Error Handling

| Error | Solution |
|-------|----------|
| "EXA_API_KEY not set" | Run `fetch-secrets` |
| "Unauthorized" | Check API key validity |
| Empty results | Try broader query or different type |
| Rate limited | Wait and retry |

## Categories Reference

- `company` - Business websites
- `research paper` - Academic papers
- `news` - News articles
- `pdf` - PDF documents
- `github` - GitHub repositories
- `tweet` - Twitter/X posts
- `personal site` - Personal blogs/sites
- `financial report` - SEC filings, reports
- `people` - People profiles
