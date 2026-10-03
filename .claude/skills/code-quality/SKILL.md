---
name: code-quality
description: Review maintainability or clean up comments in specified code without expanding the change's scope.
argument-hint: "[file_path]"
---

# Code Quality and Comment Cleanup

Meet the requested behavior and correctness constraints first. Within those constraints, prefer readability and maintainability over speculative optimization or shorter code.

## Maintainability Review

Look for problems with a concrete cost to callers or future changes:

- Change amplification: one behavior requires coordinated edits across unrelated modules.
- Cognitive load: callers must know implementation details to use an interface correctly.
- Hidden coupling: dependencies or shared state make the effects of a change hard to locate.
- Redundant or speculative abstractions: indirection adds concepts without hiding useful complexity.

Explain the affected behavior or maintenance cost before recommending a refactor. Preserve useful existing patterns and idiomatic language conventions. Offer alternatives only when their tradeoffs matter; do not treat every code smell as a defect or permission to rewrite adjacent code.

For interface design decisions, the `codebase-design` skill provides more detailed criteria when available.

## Error Handling

- Prefer representations that make invalid states difficult to create.
- Recover at a layer that can restore the operation's contract; propagate failures when recovery is unavailable.
- Preserve diagnostic context when translating errors. Do not hide a failure behind an apparent success.
- Choose fatal handling only for a demonstrated unrecoverable invariant and in line with the runtime and project's conventions.

## Comments

Keep explanations of intent, tradeoffs, contracts, non-obvious behavior, and constraints that the code cannot express clearly. Update comments made stale by the change.

Remove redundant narration where naming and structure already communicate the behavior. Preserve licenses, tooling directives, required documentation, and historical context that still explains a constraint.

When invoked for comment cleanup on a file:

1. Read enough surrounding code to understand the comments' purpose.
2. Edit misleading or redundant comments and retain useful rationale.
3. Keep runtime behavior unchanged. Suggest larger naming or structural improvements separately unless the user also requested them.

Follow the global test policy. Comment-only edits need diff inspection rather than new behavior tests. Report supported findings and actual changes; use the format that best fits their size.
