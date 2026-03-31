---
name: review
description: "Self-review of code changes (branch diff, staged, or uncommitted). Use when: reviewing code before pushing, checking diff quality, self-reviewing a PR, creating a PR (always use --peer), reviewing uncommitted work. Triggers on: '/review', 'review my changes', 'review this branch', 'self-review', 'pre-push review', 'review uncommitted', 'review staged', 'create PR', 'open PR', 'submit PR'."
allowed-tools: Bash, Read, Edit, Grep, Glob, Agent
argument-hint: "[--base <branch>] [--scope <branch|staged|uncommitted>] [--fix] [--report-only] [--peer]"
---

# Code Review

Structured two-pass code review with Fix-First approach. Supports branch diffs, staged, and uncommitted changes. Integrates with `code-quality` skill standards.

## Arguments

- `--base <branch>`: Override base branch (default: auto-detect via `gh` or `main`/`master`)
- `--scope <branch|staged|uncommitted>`: Control what diff to review (default: auto-detect)
  - `branch`: committed diff between current branch and base — requires feature branch
  - `staged`: only staged changes (`git diff --cached`) — useful before committing
  - `uncommitted`: all working tree changes (`git diff --cached` + `git diff`)
- `--fix`: Auto-fix mode — apply mechanical fixes without asking
- `--report-only`: Report only, no fixes
- `--peer`: Spawn a parallel Codex CLI peer review via background Agent (requires `codex-plugin-cc`)
- No arguments: default interactive mode (auto-fix mechanical, ask for judgment calls)

**Auto-trigger rule**: When the user asks to create/open/submit a PR, run `/review --peer` first. Address findings before proceeding with PR creation.

## Step 0: Detect Review Mode and Diff

```bash
# Detect base branch
BASE=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || git rev-parse --verify main 2>/dev/null && echo main || echo master)
CURRENT=$(git branch --show-current)
git fetch origin "$BASE" 2>/dev/null
```

**Three review scopes** (`--scope` overrides auto-detection):

| Scope | Diff source | `--peer` | Auto-selected when |
|-------|------------|----------|--------------------|
| `branch` | `git diff origin/$BASE...HEAD` | Yes (via `/codex:review`) | On feature branch with commits ahead of base |
| `staged` | `git diff --cached` | Yes (via `/codex:rescue`) | — (explicit only) |
| `uncommitted` | `git diff --cached` + `git diff` | Yes (via `/codex:rescue`) | On base branch, or branch with no commits ahead |

**Auto-detection** (when `--scope` is omitted):
1. If on feature branch with commits ahead → `branch`
2. Otherwise, if working tree has changes → `uncommitted`

**Abort conditions** — stop and inform user:
- `--scope branch` but on base branch or no commits ahead
- `--scope staged` but no staged changes
- No diff in any applicable scope

## Step 0.5: Spawn Peer Review (if --peer)

If `--peer` flag is set, **immediately** spawn a background Agent before starting Claude's own review. This runs Codex in parallel while Claude proceeds with Steps 1-4.

Requires `codex-plugin-cc` plugin installed (`/plugin install codex@openai-codex`).

**Branch mode** — use `/codex:review` (Codex native reviewer):
```
Agent(
  description: "Codex peer review",
  run_in_background: true,
  prompt: "Invoke the /codex:review skill with --base $BASE.
    Return the full structured output (verdict, findings, next_steps).
    Do not interpret or act on findings — just return raw results."
)
```

**Staged/Uncommitted mode** — pipe diff to `/codex:rescue` (native reviewer needs branch diff):
```
Agent(
  description: "Codex peer review",
  run_in_background: true,
  prompt: "Collect the working tree diff:
    - staged: git diff --cached
    - uncommitted: git diff --cached && git diff
    Then invoke /codex:rescue with the task:
      'Review this diff as a strict peer reviewer. Focus on: logic bugs, security
      vulnerabilities, error handling gaps, performance concerns, and type safety.
      For each finding: severity (CRITICAL/WARNING/INFO), file:line, problem,
      suggested fix. Be concise — issues only, no praise.'
    Include the full diff in the prompt.
    Return the raw Codex output without interpretation."
)
```

**Do not wait** for the background Agent — proceed immediately to Step 1. The Codex results will be integrated at Step 5.

If the codex plugin is not available, log a warning and skip (do not abort the review).

## Step 1: Scope Check

Read the full diff before any analysis:

**Branch mode:**
```bash
git diff origin/$BASE...HEAD
git log origin/$BASE...HEAD --oneline
```

**Uncommitted mode:**
```bash
git diff --cached   # staged changes
git diff            # unstaged changes
```

Summarize: **what changed, how many files, estimated scope** (small <50 lines, medium 50-300, large 300+).

### 1.1 Scope Drift Detection

Branch mode only: compare commit messages against actual diff. Flag if the diff does things the commits don't mention, or commits promise things the diff doesn't deliver.

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

### Peer Review Integration (if --peer)

If a background peer-review Agent was spawned in Step 0.5, check if it has completed by now. If so, parse the structured output from `/codex:review` (verdict, findings, next_steps) and append:

```
## Peer Review (Codex via codex-plugin-cc)

Verdict: <pass | fail | conditional>
Findings: <N total, grouped by severity>

{findings organized by severity — include file:line, confidence, description}

### Cross-Reference
- **Both flagged**: <issues found by both Claude and Codex — highest priority>
- **Codex only**: <issues only Codex found — evaluate and note agree/disagree with confidence>
- **Claude only**: <issues only Claude found>
```

Apply the same Iron Rule from Step 4: verify Codex findings for technical correctness before recommending action. Disagree with evidence when Codex is wrong. Weight Codex findings by their reported confidence level — low-confidence findings need extra scrutiny.
