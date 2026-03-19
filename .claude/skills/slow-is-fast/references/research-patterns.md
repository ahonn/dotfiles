# Research Patterns

## Anti-Rationalization Table

When you catch yourself thinking any of these, **stop and do the work**:

| Shortcut Thought | Reality | Required Action |
|---|---|---|
| "I already know how this API works" | Knowledge may be outdated or wrong for this version | Check docs via context7 or WebSearch |
| "This is a simple change" | Simple changes in unfamiliar code cause subtle bugs | Grep for usages, read the surrounding context |
| "I've seen this pattern before" | This codebase may use a different convention | Search for how the project actually does it |
| "The docs probably haven't changed" | Libraries release breaking changes regularly | Verify against current docs, check version |
| "I'll just read one file and start" | Cross-file dependencies are invisible from one file | Search for imports, usages, and related tests |
| "No one else has solved this" | You likely haven't searched enough | Try at least 3 different search queries |
| "Research will take too long" | Fixing wrong assumptions takes longer | Do the research — "slow is fast" |

## Reuse Decision Matrix

| Match Quality | Action | Example |
|---|---|---|
| **Exact match** — existing code/library solves the problem | Adopt directly, do not rewrite | Utility already in project, well-maintained package |
| **Partial match** — covers 70%+ of requirements | Wrap/extend the existing solution | Existing helper needs one more parameter |
| **No match** — nothing suitable found | Write custom, document why alternatives were rejected | Novel business logic, no prior art |
