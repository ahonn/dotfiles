---
name: context7-docs
description: "Query up-to-date documentation for any library using Context7 REST API. Use when: user asks for library docs, API references, code examples, or mentions 'context7'. Triggers on: 'context7 query', 'get docs for [lib]', '[lib] documentation'."
allowed-tools:
  - Bash
  - Read
---

# Context7 Documentation Query

Query up-to-date documentation and code examples using Context7 REST API.

## Scripts Location

```
./scripts/
├── context7-search  # Search for library ID
└── context7-docs    # Get documentation
```

## Workflow

### Step 1: Search for Library

```bash
./scripts/context7-search "<library-name>" "<query>"
```

**Example:**
```bash
./scripts/context7-search "next.js" "server actions"
```

**Response:** JSON with `results` array. Use `results[0].id` as library ID for next step.

### Step 2: Get Documentation

```bash
./scripts/context7-docs "<library-id>" "<query>" [type]
```

**Example:**
```bash
./scripts/context7-docs "/vercel/next.js" "server actions form submission"
```

**Parameters:**
- `library-id`: From search results (e.g., "/vercel/next.js")
- `query`: Specific question
- `type`: "txt" (default) or "json"

### Step 3: Present Results

Format the response for the user:
- Extract relevant code examples
- Summarize key documentation points

## Complete Example

```bash
# 1. Search for library
./scripts/context7-search "react" "useEffect cleanup" | jq '.results[0].id'
# Output: "/facebook/react"

# 2. Get documentation
./scripts/context7-docs "/facebook/react" "useEffect cleanup function"
```

## Query Tips

| Good Query | Bad Query |
|------------|-----------|
| "useState with TypeScript generics" | "state" |
| "Next.js App Router middleware" | "router" |
| "Prisma one-to-many relations" | "database" |

## Error Handling

| Error | Solution |
|-------|----------|
| "CONTEXT7_API_KEY not set" | Run `fetch-secrets` |
| "Unauthorized" | API key invalid, check 1Password |
| Empty results | Try different library name |
