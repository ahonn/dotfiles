---
name: branch
description: "Create git branches named by conventional-commit type: <type>/<kebab-description>. Use when: creating any new git branch, starting work that needs a branch, or naming a branch. Triggers on: 'create branch', 'new branch', 'branch off', 'checkout -b', '/branch'."
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
5. **Base** — branch off the up-to-date default branch unless the work explicitly builds on the current branch.

## Procedure

1. Derive type and description from the requested work (or "$ARGUMENTS" if provided).
2. Validate: `git check-ref-format --branch <name>`.
3. Create: `git switch -c <name>`.
