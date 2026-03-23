---
name: investigate
description: "Systematic root-cause debugging. Use when: diagnosing bugs, investigating failures, debugging flaky tests, tracing unexpected behavior. Triggers on: '/investigate', 'debug this', 'why is this failing', 'find the root cause', 'flaky test'."
allowed-tools: Bash, Read, Edit, Grep, Glob, Agent
argument-hint: "<symptom description or error message>"
---

# Systematic Debugging

Four-phase scientific method for root-cause analysis. Integrates with `slow-is-fast` reasoning principles.

**Iron Law: No fix without verified root cause. Never say "this should fix it."**

## Phase 1: Root Cause Investigation

### 1.1 Collect Symptoms

Gather all available evidence before forming any hypothesis:

- Read the full error message/stack trace
- Identify when it started (check `git log --oneline -20` for recent changes)
- Determine reproduction conditions (always? intermittent? environment-specific?)
- Check if there are related error reports or failing tests

### 1.2 Reproduce

**A bug you can't reproduce is a bug you can't fix.**

- Write down the exact reproduction steps
- Confirm you can trigger the failure consistently
- If intermittent: identify the variable (timing, data, concurrency, environment)

### 1.3 Narrow the Scope

Use binary search thinking:

- **Bisect in time**: `git log --oneline` — when did it last work?
- **Bisect in space**: Which module/layer? Add strategic logging or assertions
- **Bisect in data**: Which inputs trigger it? Minimal reproduction case

Output after Phase 1:
```
Root cause hypothesis: <one sentence>
Evidence: <what supports this>
Confidence: <low/medium/high>
```

## Phase 2: Pattern Analysis

Match against known bug patterns before investigating from scratch:

| Pattern | Signature | Where to Look |
|---------|-----------|---------------|
| **Race condition** | Intermittent, timing-dependent, "works on retry" | Shared state, async operations, missing locks/awaits |
| **Nil/null propagation** | Crash on property access, "undefined is not a function" | Optional chaining gaps, missing null checks at boundaries |
| **State corruption** | Wrong value at wrong time, stale data | Mutable shared state, cache invalidation, stale closures |
| **Integration failure** | Works in isolation, fails in composition | API contract mismatch, version skew, env config |
| **Config drift** | Works locally, fails in CI/staging/prod | Environment variables, feature flags, dependency versions |
| **Stale cache** | Old behavior persists after fix, "but I already changed that" | Build cache, module cache, CDN, browser cache, ORM cache |
| **Test pollution** | Test passes alone, fails in suite (or vice versa) | Shared global state, missing cleanup, execution order |

### For Flaky Tests

Use the polluter-finding approach:

1. Run the failing test in isolation — does it pass?
2. If yes: another test is polluting shared state
3. Binary search the test suite to find the polluter:
   ```bash
   # Run first half of suite + failing test
   # If fails: polluter is in first half. Recurse.
   # If passes: polluter is in second half. Recurse.
   ```
4. Once found: fix the shared state leak, don't just reorder tests

## Phase 3: Hypothesis Testing

### Scientific Method

For each hypothesis:

1. **Predict**: "If hypothesis X is correct, then Y should be true"
2. **Test**: Design a minimal experiment that confirms or refutes
3. **Observe**: Record actual result — no interpretation yet
4. **Conclude**: Does evidence support or refute? Update hypothesis

**Single variable**: Change only one thing per test. Multiple changes = uninterpretable results.

### 3-Strike Rule

After **3 failed hypotheses**:

- **STOP.** Do not try a 4th fix.
- Reassess: you likely have the wrong mental model of the system
- Ask: "What assumption am I making that could be wrong?"
- Consider: is this an architectural issue, not a bug?
- Present findings to user and ask for guidance

### Red Flags (you're on the wrong track)

- Fix works but you don't understand why
- Fix requires touching 5+ files for a "simple" bug
- You're adding workarounds instead of fixing root cause
- The "fix" breaks something else

## Phase 4: Implementation

### Fix Root Cause, Not Symptoms

- **Wrong**: Adding a null check where null shouldn't be possible
- **Right**: Fixing the code path that produces null

### Minimal Diff

- Change only what's necessary for the fix
- No drive-by refactoring during bug fixes
- No "while I'm here" improvements

### Regression Test

1. Write a test that **fails** with the bug present
2. Apply the fix
3. Verify the test **passes**
4. Run the full test suite — no regressions

### Verification Report

After fix is applied, output:

```
## Debug Report

Symptom: <what was observed>
Root cause: <what actually caused it>
Evidence: <how we confirmed>
Fix: <what was changed and why>
Regression test: <test name/location>
Hypotheses tested: <N> (<list with outcomes>)
Confidence: <high — verified | medium — likely but edge cases possible>
```

## Anti-Patterns

- **Shotgun debugging**: Changing random things hoping something works
- **Fix-and-pray**: Applying a fix without understanding the cause
- **Symptom patching**: Hiding the bug instead of fixing it (e.g., try/catch swallowing errors)
- **Blame the framework**: Assuming the bug is in a dependency before checking your own code
- **Stale hypothesis**: Continuing to pursue a theory after evidence contradicts it
- **Over-logging**: Adding 50 log statements instead of thinking about the problem
