---
name: peer-review
description: "Independent second-opinion code review using Codex CLI. Use when: wanting an external AI reviewer's perspective, cross-validating before push, getting a 'second pair of eyes'. Triggers on: '/peer-review', 'codex review', 'second opinion', 'peer review my changes'."
allowed-tools: Bash, Read, Grep, Glob
argument-hint: "[--base <branch>] [--uncommitted] [--commit <sha>] [--model <model>] [--focus <area>]"
---

# Peer Review via Codex CLI

Independent code review using OpenAI Codex CLI as a second reviewer agent. Codex runs in read-only sandbox — it cannot modify any files.

## Why a Second Reviewer

Different model families (Claude vs GPT) have different blind spots. A peer review from a separate agent catches issues that self-review misses, similar to how a human teammate provides a fresh perspective.

## Prerequisites

Codex CLI must be installed and authenticated:
- `codex --version` should return a version
- Codex handles its own auth via `codex login` or config

If not available, inform the user and stop.

## Arguments

- `--base <branch>`: Review changes against a specific base branch
- `--uncommitted`: Review staged, unstaged, and untracked changes
- `--commit <sha>`: Review a specific commit
- `--model <model>`: Override Codex model (default: uses Codex config default)
- `--focus <area>`: Custom focus area passed as review instructions (e.g., "security", "performance", "error handling")

No arguments: auto-detect — if on a feature branch, review against base; otherwise review uncommitted changes.

## Step 0: Preflight

```bash
# Verify Codex CLI is available
codex --version

# Detect review target
BASE=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || git rev-parse --verify main 2>/dev/null && echo main || echo master)
```

**Determine review mode:**
1. If `--uncommitted` → use `--uncommitted` flag
2. If `--commit <sha>` → use `--commit <sha>` flag
3. If `--base <branch>` → use `--base <branch>` flag
4. If on a feature branch with commits ahead of base → use `--base $BASE`
5. If uncommitted changes exist → use `--uncommitted`
6. Otherwise → abort, nothing to review

**Abort conditions:**
- No Codex CLI installed
- No changes to review (no diff, no uncommitted changes)

## Step 1: Gather Context

Before invoking Codex, gather context to present alongside the review:

```bash
# Scope summary for user
git diff origin/$BASE...HEAD --stat   # or appropriate diff for the mode
git log origin/$BASE...HEAD --oneline
```

Report to user: **review mode** (branch/uncommitted/commit), **scope** (files changed, lines), and **Codex model** being used.

## Step 2: Run Codex Review

Build and execute the Codex review command. Always use `codex exec review` for the `-o` output capture.

```bash
# Base branch review (default)
codex exec review \
  --base "$BASE" \
  --ephemeral \
  -o /tmp/peer-review-output.md \
  "$CUSTOM_INSTRUCTIONS"

# Uncommitted changes
codex exec review \
  --uncommitted \
  --ephemeral \
  -o /tmp/peer-review-output.md \
  "$CUSTOM_INSTRUCTIONS"

# Specific commit
codex exec review \
  --commit "$SHA" \
  --ephemeral \
  -o /tmp/peer-review-output.md \
  "$CUSTOM_INSTRUCTIONS"
```

**Custom instructions** — always include this base prompt, appending any `--focus` area:

```
Review this code as a strict but fair peer reviewer. Focus on:
1. Logic bugs and correctness issues
2. Security vulnerabilities (injection, auth bypass, data exposure)
3. Error handling gaps (swallowed errors, missing edge cases)
4. Performance concerns (N+1 queries, unnecessary computation, memory leaks)
5. API contract and type safety issues

For each finding, specify: severity (CRITICAL/WARNING/INFO), file:line, problem description, and suggested fix.
Be concise. Do not praise code — only report issues and improvements.
```

**Model override**: if `--model` is specified, add `-m <model>` to the command.

**Timeout**: set a 120-second timeout. If Codex hangs, kill and report partial output.

## Step 3: Present Findings

Read the Codex output and present it to the user in a structured format:

```
## Peer Review (Codex CLI)

**Reviewer**: Codex CLI v{version} / {model}
**Mode**: {branch|uncommitted|commit}
**Scope**: {N} files, {M} lines changed

---

### Findings

{Codex output, formatted and organized by severity}

---

### Cross-Reference Notes

{Any observations about how Codex findings relate to or differ from
what Claude's own /review would catch — only if /review was also run}
```

## Step 4: Triage Assistance

After presenting findings, offer to help the user triage:

1. **Agree** — findings that align with Claude's own assessment (high confidence)
2. **Disagree** — findings where Claude believes Codex is wrong (explain why)
3. **Investigate** — findings that need more context to evaluate

For each disagreement, provide Claude's counter-argument with evidence. The user makes the final call.

**Iron Rule: Do not blindly trust Codex findings.** Apply the same review rigor as Step 4 of `/review` — verify technical correctness before recommending action.

## Step 5: Summary

```
## Peer Review Summary

Reviewer: Codex CLI {version} / {model}
Scope: {description}

CRITICAL: {N} findings
WARNING:  {N} findings
INFO:     {N} findings

Triage:
- Agree:       {N} (recommend fixing)
- Disagree:    {N} (Codex likely wrong — see notes)
- Investigate: {N} (need more context)

Next steps: {suggestions — e.g., "run /review for self-review", "fix critical items", etc.}
```

## Combining with /review

For maximum coverage, run both:
1. `/review` — Claude's self-review (catches logic, architecture, code quality)
2. `/peer-review` — Codex's independent review (catches different blind spots)

The two reviews complement each other. Findings that both reviewers flag are highest priority.
