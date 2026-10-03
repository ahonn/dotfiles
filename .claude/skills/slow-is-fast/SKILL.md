---
name: slow-is-fast
description: Plan changes with unresolved behavior, cross-module tradeoffs, or costly implementation decisions.
user-invocable: false
---

# Slow is Fast

Reduce the uncertainty that could change the implementation before committing to an approach. Use Research → Plan → Code at a depth proportional to the task; do not turn each phase into a mandatory deliverable or approval gate.

## Research

- Inspect the relevant implementation, callers, and existing checks. Reuse findings already established in the conversation.
- Identify which unknowns affect correctness, compatibility, or scope. A local edit with an established pattern may need only nearby code; a cross-module change may need contract and lifecycle analysis.
- Check installed versions and official documentation when external behavior is uncertain or version-dependent. Choose available tools; no specific search provider or agent type is required.
- Delegate only a bounded question that can run independently alongside useful local work.

For a difficult reuse or dependency decision, consult [research-patterns.md](references/research-patterns.md). It is not required reading for ordinary edits.

## Plan

State the intended outcome, the constraints that affect the solution, and how completion will be assessed. Include the test mode from global AGENTS.md when verification requires an explanation.

Choose the simplest approach that meets the requirements and correctness constraints. Compare alternatives only when they differ meaningfully in behavior, maintenance cost, or reversibility. Do not invent extra options to fill a quota.

Keep bug fixes scoped to the failure. For features, finish the requested behavior and its necessary error paths without adding speculative capabilities. Identify consequential decisions before implementing them; ask only for unresolved decisions that materially change scope or risk.

Resolve unknowns that block a sound implementation. Describe bounded assumptions or verification limits for the rest. A numerical confidence score is not evidence and is not an exit requirement.

## Implement and Finish

- Continue directly when the approach is clear and authorized. Do not wait for approval merely because planning is complete.
- Make reviewable changes, inspect intermediate results, and revise the approach if new evidence contradicts it.
- Follow the selected test mode. Fix failures caused by the change and rerun affected checks; broaden validation when new evidence or repository requirements justify it.
- Finish the requested delivery scope. Report the resulting behavior, observed validation, and concrete remaining limits.

Correctness and the user's requirements constrain the solution. Within those constraints, prefer readability and maintainability over speculative performance gains or shorter code.
