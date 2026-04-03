---
name: opencode-delegate
description: "Delegate a coding task to OpenCode via ACP. Claude Code constructs the prompt, dispatches via acpx, then reviews the result (spec compliance + code quality). Use when: offloading implementation to OpenCode, using OpenCode as implementer backend. Triggers on: '/opencode-delegate', 'delegate to opencode', 'let opencode handle this'."
allowed-tools: Bash, Read, Edit, Grep, Glob, Write
argument-hint: "<task description>"
---

# OpenCode Delegate

Delegate a single coding task to OpenCode via ACP, then review the result.

**Role split**: Claude Code = orchestrator + reviewer. OpenCode = implementer.

**Core loop**: Record baseline → construct prompt → acpx exec → review diff → pass or incremental fix (max 3 attempts) → report outcome.

**Prerequisites**:
- `acpx` installed and in PATH (on Nix systems, `npx acpx` may not work; use `npx -y acpx@latest` or ensure `acpx` is directly available)
- `opencode` available as an ACP-compatible agent
- Current directory is a git repo with a clean or committed working tree

---

## Workflow

### Step 1: Record Baseline

```bash
BASELINE=$(git rev-parse HEAD)
```

Save this SHA — it anchors every diff and every pass/fail decision for the entire delegation cycle.

### Step 2: Construct Prompt

Claude Code does the research (reads files, understands codebase, embeds relevant code context). OpenCode receives a self-contained prompt and executes.

Build a prompt file with these sections:

~~~markdown
# Task
{one-paragraph description of what to implement or fix}

# Context
{relevant code snippets, file paths, architecture notes — embedded by Claude Code}

# Constraints
- Work inside the repository at {project-path}
- Do NOT modify files outside the task scope
- Commit your changes with a descriptive conventional commit message
- Do NOT run destructive git operations (reset, force-push, rebase)

# Requirements
{numbered list of acceptance criteria}
1. {requirement}
2. {requirement}
...
~~~

Write the prompt to a temp file:

```bash
cat > /tmp/opencode-prompt-<short-id>.md << 'PROMPT'
<constructed prompt content>
PROMPT
```

Use a short random ID (e.g., first 8 chars of `uuidgen` or `$(date +%s)`) to avoid collisions.

### Step 3: Delegate to OpenCode

```bash
acpx --approve-all --format quiet --timeout 300 --cwd <project-path> opencode exec --file /tmp/opencode-prompt-<short-id>.md
```

| Parameter | Purpose |
|---|---|
| `--approve-all` | Auto-approve all tool calls (OpenCode runs autonomously) |
| `--format quiet` | Suppress verbose output; only errors and final result |
| `--timeout 300` | 5-minute hard timeout for the execution |
| `--cwd <project-path>` | Set working directory to the project root |
| `opencode exec --file` | Run OpenCode in one-shot mode with the prompt file |

Use the Bash tool with `timeout: 330000` (slightly above acpx's 300s timeout to allow graceful shutdown).

### Step 4: Capture and Inspect Changes

```bash
git diff $BASELINE..HEAD
git log --oneline $BASELINE..HEAD
```

- If the diff is **empty** (no changes), treat this as a failure. Retry by constructing a new prompt that emphasizes OpenCode must make actual file modifications and commit them.

### Step 5: Spec Compliance Review

Claude Code reviews the diff directly (no subagent needed).

| Check | Question |
|---|---|
| All requirements covered | Does the diff satisfy every numbered requirement from Step 2? |
| Edge cases handled | Are boundary conditions, error states, and empty inputs addressed? |
| No scope creep | Did OpenCode stay within the requested scope without unrelated changes? |
| Commit exists | Is there at least one commit between baseline and HEAD? |

- **FAIL** → go to Step 6 (Incremental Fix)
- **PASS** → go to Step 7 (Code Quality Review)

### Step 6: Incremental Fix

Construct a fix prompt that includes:

~~~markdown
# Previous Changes
{relevant diff fragments from git diff $BASELINE..HEAD}

# Review Feedback
{specific issues with file path, line number, and what is wrong}
1. {file:line — issue description}
2. {file:line — issue description}

# Fix Requirements
{what OpenCode must do to resolve each issue}
- Fix each issue listed above
- Do NOT revert previous correct changes
- Commit your fixes with a descriptive message
~~~

Write to a new temp file → delegate again (back to Step 3).

**Attempt tracking**: After 3 total attempts (1 initial + 2 fix rounds), stop the loop and report the current state to the user. Do not keep retrying indefinitely.

### Step 7: Code Quality Review

Only reached after spec compliance passes.

| Check | Question |
|---|---|
| Readability | Are names clear, functions focused, and logic easy to follow? |
| Security | No hardcoded secrets, no injection risks, no unsafe patterns? |
| Test coverage | Are tests added or updated for the changed behavior? |
| Style consistency | Does the code match the project's existing conventions? |

- **FAIL** → go to Step 6 (Incremental Fix) with quality-specific feedback
- **PASS** → go to Step 8 (Report Completion)

### Step 8: Report Completion

Clean up the temp prompt file(s):

```bash
rm -f /tmp/opencode-prompt-*.md
```

Output a brief status:

**Success example:**
```
OpenCode Delegate: PASS
  Attempts: 1/3
  Commits: 2 (abc1234, def5678)
  Files changed: 3
  Review: spec compliance PASS, code quality PASS
```

**Failure example:**
```
OpenCode Delegate: FAIL (max attempts reached)
  Attempts: 3/3
  Remaining issues:
    - src/utils.ts:42 — missing null check on optional parameter
    - src/utils.test.ts — no test for empty input case
  Action required: manual intervention or re-delegate with refined requirements
```

---

## Error Handling

| Scenario | Detection | Action |
|---|---|---|
| acpx not installed | `command -v acpx` fails | Tell user to install: `npm install -g acpx` or ensure it is in PATH |
| OpenCode not available | acpx exits with connection/provider error | Report the error message; suggest checking OpenCode configuration |
| Timeout | acpx exits with timeout error or Bash tool times out | Report timeout; suggest breaking the task into smaller pieces |
| Execution failure | acpx exits with non-zero code | Capture stderr; include in report to user |
| Empty diff | `git diff $BASELINE..HEAD` produces no output | Retry once with explicit instruction to modify files and commit; if still empty, report failure |

---

## Red Flags

**NEVER:**
- Execute `git reset --hard` or any destructive git operation automatically
- Skip either review stage (spec compliance or code quality)
- Proceed with unfixed review issues
- Show OpenCode's raw output to the user unless they explicitly request it
- Delegate without pre-reading relevant files to embed context in the prompt

**ALWAYS:**
- Record the baseline SHA before delegating
- Include specific review feedback in fix prompts (file paths, line numbers, concrete descriptions — not vague complaints)
- Report attempt count and failure reasons to the user
- Clean up temp prompt files after completion

---

## Integration

This is an **atomic skill**: it handles one task delegation + review cycle.

**Standalone usage:**
```
/opencode-delegate "add input validation to UserForm"
```

**As implementer backend:** Other skills (e.g., subagent-driven-development) can reference this skill to use OpenCode as the execution engine for individual plan steps.

**Recommended companions:**
- `using-git-worktrees` — isolate delegation work in a worktree
- `writing-plans` — break large tasks into delegatable units
- `subagent-driven-development` — orchestrate multiple delegations
- `finishing-a-development-branch` — finalize after delegation completes

**Scope boundaries:** This skill does NOT read plans, manage tasks, create worktrees, or execute destructive git operations. It handles exactly one thing: delegate → review → report.
