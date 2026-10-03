---
name: investigate
description: Diagnose reproducible or intermittent failures by tracing evidence to a root cause and verifying a targeted fix.
allowed-tools: Bash, Read, Edit, Grep, Glob, Agent
argument-hint: "<symptom description or error message>"
---

# Systematic Debugging

Use evidence to explain the failure before changing behavior. Scale investigation to uncertainty and impact; a clear stack trace may need only a short trace, while intermittent failures may need instrumentation.

Follow the global AGENTS.md for authorization and test mode. Continue work already authorized by the session. Do not impose additional approval gates, a fixed retry limit, or mandatory test-first development.

## Collect evidence and reproduce

- Read the complete error and relevant execution path. Identify the expected and observed behavior.
- Establish when the failure began and whether it depends on inputs, timing, environment, or recent changes.
- Reproduce with the smallest relevant command, test, or manual sequence. For intermittent failures, record the conditions and frequency.
- If reproduction is unavailable, use logs, traces, and code evidence to narrow the cause. State the remaining uncertainty; do not claim verification from inspection alone.
- Inspect actual OS, runtime, SDK, or dependency versions when they affect the hypothesis. Do not diagnose version problems from memory.
- For unavailable tools or external services, inspect the failure enough to choose a useful next step. Use an equivalent authorized fallback when appropriate; do not turn an unrelated tool outage into a separate repair project.

## Narrow the cause

Trace the failing value or operation across boundaries. Compare working and failing cases, and vary one relevant factor at a time when practical.

| Pattern | Evidence to seek |
|---------|------------------|
| Race condition | Timing-dependent shared state, missing sequencing, stale async results |
| Null propagation | The earliest point an expected value becomes absent |
| State corruption | Mutation, cache invalidation, stale closures, ownership violations |
| Integration failure | Contract mismatch, version skew, differing configuration |
| Stale cache | Cached content or build artifacts that differ from the current source |
| Test pollution | Shared state, missing cleanup, order-dependent behavior |

A test passing in isolation does not prove test pollution. Compare suite execution, concurrency, environment, and timing. If order dependence is established, narrow the predecessor set to find the shared-state leak; do not fix it by reordering tests.

## Test hypotheses

For each material hypothesis, identify the evidence, predict an observable result, run a focused experiment, and update the explanation from the result. Avoid changing several unrelated things and attributing success to one of them.

When experiments stop producing new information, revisit assumptions and widen the trace. A recurring symptom after a patch is evidence that the explanation or fix is incomplete: check whether the patch executed, reassess the causal chain, and preserve evidence that still holds. Do not discard valid evidence or stop at an arbitrary attempt count.

Use an independent opinion when a complex or high-risk diagnosis would benefit from it, or when explicitly requested. Verify that opinion against the code and observations. Ask the user only for missing evidence, access, or a decision that blocks further useful authorized work.

## Implement and verify

Fix the demonstrated cause with a focused change. Preserve necessary error handling; distinguish a valid boundary guard from a guard that merely hides a broken invariant. Avoid unrelated refactors, and remove temporary instrumentation when it is no longer useful.

Apply the test mode chosen under global AGENTS.md. Add a regression test when that mode calls for one; test-first is optional unless explicitly selected. Run the relevant existing checks and required project checks. Broaden validation only when the change or results justify it.

Report the root cause, supporting evidence, change, checks actually performed, and material unverified behavior. If the cause remains uncertain, distinguish a mitigation or hypothesis from a confirmed fix.
