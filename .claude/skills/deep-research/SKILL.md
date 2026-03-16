---
name: deep-research
description: "Deep research workflow before code modifications. Enforces codebase search, documentation lookup, and solution survey before writing any code. Applied automatically for moderate+ tasks."
user-invocable: false
---

# Deep Research Before Code

**Core rule**: Never modify code based on assumptions alone. Ground every decision in evidence from the codebase, documentation, and known solutions.

## When This Applies

| Complexity | Research Depth |
|------------|---------------|
| **Trivial** (typo, formatting, <10 lines) | Minimal — quick grep for context |
| **Moderate** (single file, non-trivial logic) | Standard — all 3 phases below |
| **Complex** (cross-module, new architecture) | Deep — use Explore agent, WebSearch, context7 |

### Skip Conditions

Research can be minimal when:
- Pure formatting, typo, or rename fixes
- User explicitly provides the exact solution or says "just do it"
- Follow-up changes in same conversation where research was already done
- The change is within code you just wrote in this conversation

## Research Phases

Execute these **before** entering Plan mode. Summarize findings before proposing any approach.

For moderate+ tasks, **use Explore agent** (`context: fork`) to run research in an isolated context, keeping the main conversation clean.

### Phase 1: Codebase Search

Understand what already exists. Do not reinvent or contradict existing patterns.

- **Grep** for related function names, types, patterns, error messages
- **Glob** for related files by naming convention
- **Read** key files to understand existing architecture and conventions
- For broad exploration, use **Explore agent** to parallelize searches

**Output**: List of relevant files, existing patterns, and conventions found.

### Phase 2: Documentation Lookup

Verify API behavior, library usage, and framework conventions against official sources.

- Use **context7** (`resolve-library-id` → `query-docs`) for libraries/frameworks involved
- Use **WebSearch** when context7 lacks coverage or for newer APIs
- Check changelogs/migration guides if version-specific behavior is involved

**Output**: Key API details, correct usage patterns, version-specific notes.

### Phase 3: Solution Survey & Reuse Decision

For non-trivial problems, survey known approaches before committing to one.

- Search for common pitfalls, edge cases, and known issues related to the problem
- Look for established patterns or prior art in the ecosystem
- Identify trade-offs between candidate approaches

Apply the **reuse decision matrix** to each finding:

| Match Quality | Action | Example |
|---------------|--------|---------|
| **Exact match** — existing code/library solves the problem | Adopt directly, do not rewrite | Utility already in project, well-maintained npm package |
| **Partial match** — covers 70%+ of requirements | Wrap/extend the existing solution | Existing helper needs one more parameter |
| **No match** — nothing suitable found | Write custom, document why alternatives were rejected | Novel business logic, no prior art |

**Output**: 1-3 candidate approaches with evidence-backed pros/cons and reuse decisions.

## Anti-Rationalization Table

When you catch yourself thinking any of these, **stop and do the work**:

| Shortcut Thought | Reality | Required Action |
|------------------|---------|-----------------|
| "I already know how this API works" | Knowledge may be outdated or wrong for this version | Check docs via context7 or WebSearch |
| "This is a simple change" | Simple changes in unfamiliar code cause subtle bugs | Grep for usages, read the surrounding context |
| "I've seen this pattern before" | This codebase may use a different convention | Search for how the project actually does it |
| "The docs probably haven't changed" | Libraries release breaking changes regularly | Verify against current docs, check version |
| "I'll just read one file and start" | Cross-file dependencies are invisible from one file | Search for imports, usages, and related tests |
| "No one else has solved this" | You likely haven't searched enough | Try at least 3 different search queries |
| "Research will take too long" | Fixing wrong assumptions takes longer | Do the research — "slow is fast" |

## Integration with Plan/Code Workflow

```
Research (this skill) → Plan (plan-code-workflow) → Code (plan-code-workflow)
```

- Research findings feed directly into Plan mode options
- Each Plan option should reference specific findings from research
- If research reveals the problem is simpler/different than expected, adjust scope before planning

## Anti-Patterns

- **Cargo-cult coding**: Copying patterns without understanding why they exist in the codebase
- **Stale knowledge**: Using remembered API behavior instead of checking current docs
- **Premature implementation**: Jumping to code after reading only one file
- **Research theater**: Searching but ignoring findings when they contradict your initial idea
- **Dependency bloat**: Adding a library when a 5-line solution exists in the project
- **NIH syndrome**: Rewriting what already exists because you didn't search thoroughly
