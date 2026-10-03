---
name: tdd
description: Use red-green-refactor when the user requests test-first development or the applicable testing policy selects TDD.
---

# Test-Driven Development

Use this workflow only for test mode `tdd` or an explicit test-first request. The applicable AGENTS.md testing policy owns mode selection; this skill does not turn `skip`, `verify-only`, or `add-tests` into TDD.

## Establish the boundary

Inspect the implementation, nearby tests, and the relevant interface before the first test. Read domain documentation only when it resolves uncertainty about the behavior or vocabulary under test.

- Use the existing test harness for this surface. If none exists, follow the task's scope and testing policy; introduce one only when the request supports it.
- Choose the smallest public boundary that exposes the required behavior. State the boundary in the plan when useful; routine test placement does not require user confirmation.
- Ask only when an unresolved behavior or interface decision materially changes scope or risk. Continue independent work while that decision is pending.

## Work in vertical slices

1. Select one observable behavior from the requirement or reproduced bug.
2. Write a focused test and run it. Confirm it fails for the missing behavior, not a broken fixture, import, or environment.
3. Add the implementation needed for that behavior and run the relevant test again.
4. Refactor when it improves the changed code, keeping the relevant tests green. A separate review skill is not a prerequisite.
5. Repeat for the next meaningful behavior. Finish with the checks appropriate to the changed surface and report only checks actually run.

Do not write a batch of speculative tests before implementing any behavior. Let each completed slice inform the next one.

## Keep tests worth maintaining

- Verify behavior through public interfaces, with expected results drawn from a requirement, worked example, or other independent source of truth.
- Avoid private-method assertions and internal call-order checks unless that interaction is itself the contract.
- Prefer real collaborators where practical. Isolate external boundaries when needed for reliable, focused tests.
- Cover meaningful failure paths and regressions without mirroring the implementation or adding cases solely to increase coverage.

Read [tests.md](tests.md) when choosing assertions or reviewing test quality. Read [mocking.md](mocking.md) when external dependencies need isolation. Load only the guidance relevant to the current slice.
