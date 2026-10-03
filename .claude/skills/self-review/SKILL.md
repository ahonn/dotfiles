---
name: self-review
description: Review branch, staged, or uncommitted changes for actionable defects before commit, push, or PR creation.
allowed-tools: Bash, Read, Edit, Grep, Glob, Agent
argument-hint: "[--base <branch>] [--scope <branch|staged|uncommitted>] [--fix] [--report-only] [--peer]"
---

# Self-Review

Review the requested diff against its intended behavior and surrounding contracts. Prioritize correctness, security, and maintainability. Use `code-quality` for relevant standards; avoid speculative findings or changes that only satisfy a preferred style.

Follow global AGENTS.md for authorization and test mode. PR creation warrants a local review, not an automatic independent-review requirement. Existing permission to implement or fix the work carries into review.

## Arguments and scope

- `--base <branch>`: Use the specified base. Otherwise inspect the PR base or repository default branch; verify the ref exists rather than guessing from a shell fallback.
- `--scope branch`: Review committed changes relative to the merge base with the selected base.
- `--scope staged`: Review `git diff --cached`.
- `--scope uncommitted`: Review staged and unstaged changes, including relevant untracked files.
- `--fix`: Apply technically verified fixes within the requested scope.
- `--report-only`: Report findings without editing.
- `--peer`: Request an independent review of the same scope using available reviewer tools.
- Without a fix flag, preserve the session's authorization. A review-only request produces findings; an implementation or fix request permits relevant corrections.

Inspect `git status`, the current branch, and available refs before selecting scope. Without an explicit scope, cover the requested work's final state: include relevant branch commits and staged, unstaged, or untracked changes that belong to the task. Do not omit a newly implemented fix because earlier work is already committed. Keep unrelated user changes outside the review. An explicitly requested revision or scope limits the review to that selection.

Use the remote-tracking base when current enough for the task; fetch when freshness matters. For committed branch changes, use `git diff <base>...HEAD` and inspect the associated commits. When the default task scope also includes local work, inspect `git diff HEAD` and relevant untracked files, then read the combined final implementation. If the requested scope is empty or the base cannot be established, report that limitation rather than silently reviewing another scope.

## Inspect the change

Read the full relevant diff and enough surrounding code to understand callers, dependencies, and error paths. Compare implementation with the requested outcome and, where relevant, the PR description or commit messages.

Prioritize checks according to the change:

- Correctness: invariants, edge cases, nullability, state transitions, and async ordering.
- Data and security: authorization, input handling, secret exposure, unsafe writes, and concurrency.
- Contracts: API compatibility, error semantics, lifecycle cleanup, and dependency direction.
- Maintainability: misleading names or comments, unnecessary indirection, duplication, and related dead code.
- Performance: concrete expensive work or regressions on the affected path; do not request memoization without a reason.
- Validation: missing evidence for changed behavior under the chosen test mode, not missing tests merely because code changed.

For each actionable finding, include the affected file and location, failure conditions, consequence, supporting evidence, and a suggested correction. Separate confirmed defects from unresolved questions. Pre-existing issues outside scope and subjective preferences should not become blockers.

## Independent review

Use an independent reviewer when `--peer` is requested, or when complex or high-risk changes need a second opinion. Do not require it for routine PRs. Give the reviewer a bounded scope, exact diff or revision, expected behavior, and relevant constraints; request findings without edits.

If available, `codex-plugin-cc` provides `/codex:review` for branch review and `/codex:rescue` for targeted analysis. Use capabilities actually installed in the current environment; do not assume a plugin or specific tool is present. If an explicitly requested reviewer is unavailable, disclose the limitation and complete the useful local review.

Run local review alongside an independent review only when they can proceed independently. Integrate the returned findings before declaring the requested peer review complete. Verify each finding rather than accepting it because of reviewer agreement or confidence.

## Resolve findings

- In fix-authorized work, apply confirmed corrections within scope, including logic changes whose intended behavior is established.
- Follow the global authorization boundaries for API or schema changes, destructive actions, and material scope changes. Ask only when a required decision remains unresolved; do not ask separately for every logic edit.
- For review-only work, report defects and proposed corrections without making edits.
- Reject incorrect feedback with concrete evidence. Avoid adding speculative abstractions or behavior to satisfy a reviewer.

After corrections, inspect the final diff and validate according to the global test mode and required project checks. Do not repeat checks without a relevant change or unresolved concern.

## Completion

Lead with actionable remaining findings, ordered by impact. Otherwise state that no actionable defects were found within the reviewed scope. Summarize fixes made, checks actually performed, and material limitations; absence of findings is not proof that no bugs exist. Keep the report proportional to the change and do not imply a peer review ran when it did not.
