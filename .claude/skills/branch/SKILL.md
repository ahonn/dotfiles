---
name: branch
description: Create or name a Git branch using the user's conventional-commit naming rules.
allowed-tools: Bash
argument-hint: "[work description or ticket]"
---

# Conventional Branch Names

Branch names use the same type vocabulary as conventional commits:

```
<type>/<short-kebab-description>
```

Examples: `feat/user-auth`, `fix/login-crash`, `refactor/api-client`, `chore/update-deps`.

## Rules

1. **Type** — the conventional-commit type the dominant commit on this branch would have: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `revert`.
2. **Description** — 2–4 words, kebab-case, specific: what the branch delivers, not how. Lowercase only, no spaces.
3. **Ticket IDs** — if the work has a ticket, put its ID after the type: `feat/lin-123-user-auth`.
4. **No agent-branded prefixes** — never `codex/...`, `claude/...`, or `agent/...`. The branch describes the work, not the tool that wrote it.
5. **Base** — use the user's requested starting point. Otherwise prefer the up-to-date default branch, except when the task clearly continues current branch work. Inspect repository state before choosing it; preserve uncommitted work.

## Procedure

If the user only asks for a branch name, propose the name without changing repository state. Use the creation steps when creating a branch is within the requested work.

1. Derive type and description from the requested work (or "$ARGUMENTS" if provided).
2. Validate: `git check-ref-format --branch <name>`.
3. Inspect `git status --short --branch` and the available refs. Resolve the requested base; if a fresh remote base is needed, fetch that ref and verify it before proceeding. Do not assume the current checkout is the default branch or up to date.
4. Create with `git switch -c <name> <verified-base>`; omit the base only when intentionally branching from current HEAD. If switching would disturb unrelated edits, use an isolated worktree when appropriate or ask for the unresolved starting-point decision. Do not stash, discard, reset, or overwrite work implicitly.
