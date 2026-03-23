---
name: review
description: "Pre-push self-review of current branch changes. Use when: reviewing code before pushing, checking diff quality, self-reviewing a PR. Triggers on: '/review', 'review my changes', 'review this branch', 'self-review', 'pre-push review'."
allowed-tools: Bash, Read, Edit, Grep, Glob, Agent
argument-hint: "[--base <branch>] [--fix] [--report-only]"
---

# Pre-Push Self-Review

Structured two-pass code review with Fix-First approach. Integrates with `code-quality` skill standards.

## Arguments

- `--base <branch>`: Override base branch (default: auto-detect via `gh` or `main`/`master`)
- `--fix`: Auto-fix mode — apply mechanical fixes without asking
- `--report-only`: Report only, no fixes
- No arguments: default interactive mode (auto-fix mechanical, ask for judgment calls)

## Step 0: Detect Base Branch and Diff

```bash
# Detect base branch
BASE=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || git rev-parse --verify main 2>/dev/null && echo main || echo master)
git fetch origin "$BASE" 2>/dev/null
```

**Abort conditions** — stop and inform user:
- On the base branch itself (no feature branch)
- No diff against base (`git diff origin/$BASE...HEAD` is empty)
- Unstaged changes exist — ask user to commit or stash first

## Step 1: Scope Check

Read the full diff before any analysis:

```bash
git diff origin/$BASE...HEAD
git log origin/$BASE...HEAD --oneline
```

Summarize: **what changed, how many files, estimated scope** (small <50 lines, medium 50-300, large 300+).

### 1.1 Scope Drift Detection

Compare commit messages against actual diff. Flag if the diff does things the commits don't mention, or commits promise things the diff doesn't deliver.

## Step 2: Two-Pass Review

### Pass 1 — CRITICAL (blockers, must fix before merge)

| Category | What to Check |
|----------|---------------|
| **Data Safety** | SQL injection, unvalidated input in queries, missing parameterization |
| **Race Conditions** | Shared mutable state, missing locks, TOCTOU, concurrent access patterns |
| **Security Boundaries** | User input trust, auth checks, XSS vectors, secret exposure |
| **Error Handling** | Swallowed errors, missing error paths, unhandled promise rejections |
| **Breaking Changes** | API contract changes, type signature changes, removed exports |

### Pass 2 — INFORMATIONAL (improve quality, non-blocking)

| Category | What to Check |
|----------|---------------|
| **Dead Code** | Unused imports, unreachable branches, commented-out code |
| **Magic Values** | Unexplained numbers/strings that should be named constants |
| **Test Gaps** | New logic without test coverage, edge cases untested |
| **Complexity** | Functions doing too much, deep nesting, unclear naming |
| **Consistency** | Pattern deviations from surrounding code, style inconsistencies |
| **Performance** | N+1 queries, unnecessary re-renders, missing memoization |

Apply `code-quality` skill standards: deep modules, information hiding, readability > correctness > performance.

### Review Output Format

For each finding:

```
[CRITICAL|INFO] <category> — <file>:<line>
  Problem: <one sentence>
  Evidence: <code snippet or reasoning>
  Action: AUTO-FIX | ASK | NOTE
```

## Step 3: Fix-First Heuristic

Classify each finding:

**AUTO-FIX** (apply without asking):
- Unused imports or dead code removal
- Missing error handling that has one obvious correct form
- Typos in strings, comments, variable names
- Formatting inconsistencies
- Stale comments that contradict current code

**ASK** (present to user for decision):
- Logic changes, even "obvious" ones
- Architectural concerns
- Trade-off decisions (performance vs readability)
- Anything where two reasonable engineers could disagree

**NOTE** (report only, no action):
- Pre-existing issues outside the current diff
- Style preferences without clear right answer
- Future improvement suggestions

### Execution

If `--report-only`: output all findings, stop.
If `--fix`: apply all AUTO-FIX items, report ASK and NOTE items.
Default: apply AUTO-FIX items, present ASK items one at a time via user question, report NOTE items.

For each AUTO-FIX applied:
1. Make the edit
2. Log: `[AUTO-FIXED] <category> — <file>:<line> — <what changed>`

For each ASK item:
1. Present the problem, evidence, and proposed fix
2. Wait for user response
3. Apply or skip based on response

## Step 4: Receiving Review Feedback

When processing review feedback (from user, PR comments, or other reviewers):

**Iron Rule: Verify before implementing.**

1. **Read the feedback** — understand what's being suggested
2. **Verify technical correctness** — is the suggestion actually right?
3. **Check for YAGNI** — does this add speculative complexity?
4. **Push back if wrong** — respectfully explain why, with evidence

Never apply feedback just because it came from a reviewer. Never respond with performative agreement ("You're absolutely right!"). Either the feedback improves the code or it doesn't.

## Step 5: Summary

After review is complete, output:

```
## Review Summary

Scope: <small/medium/large> (<N> files, <M> lines changed)
Scope drift: <none | description>

CRITICAL: <N> found, <M> fixed, <K> need decision
INFO:     <N> found, <M> fixed, <K> noted

Changes made:
- [AUTO-FIXED] <list>
- [USER-APPROVED] <list>

Remaining:
- [ASK] <items awaiting decision>
- [NOTE] <items for awareness>
```
