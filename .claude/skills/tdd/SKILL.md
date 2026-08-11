---
name: tdd
description: "Red-green test-first workflow for behavior with a clear, user-confirmed seam. Use when: user asks for TDD/test-first/red-green, adding non-trivial domain logic with an existing test harness, or fixing a bug that needs a regression test under mode tdd. Do NOT use when: config/docs/Nix/home-manager only, pure styling/copy, renames, scaffolding, prototypes, no test runner for this surface, user said skip tests, verification is build/flake-check only, or AGENTS test mode is skip|verify-only|add-tests-after."
---

# Test-Driven Development

TDD is the red → green loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle — consult them before and during the loop, not after.

**Not the default workflow.** Most tasks use AGENTS.md test modes `skip`, `verify-only`, or `add-tests` without this skill. Only continue past the gate when mode is `tdd` (or the user explicitly ordered test-first).

When exploring the codebase, read the project's domain docs if they exist (`CLAUDE.md`, glossary, ADRs) so test names and interface vocabulary match the project's domain language.

## Gate (before any red test)

Answer all three before writing a failing test:

1. **Harness?** Is there a runnable test runner for this change surface (or is the user asking to introduce one for real domain logic)?
2. **Logic-bearing?** Is the behavior domain logic / regression-worthy — not config, docs, Nix, pure UI chrome, rename, or scaffolding?
3. **Opt-in?** Did the user ask for TDD/test-first/red-green, or is AGENTS test mode explicitly `tdd`?

If any answer is no → **stop**. State `Test mode: skip | verify-only | add-tests` and a one-line rationale. Do not invent a harness, force red→green, or load the rest of this skill as a mandatory process.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification — "user can checkout with valid cart" tells you exactly what capability exists — and survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Seams — where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Before writing any test, write down the seams under test and confirm them with the user. No test is written at an unconfirmed seam. You can't test everything — agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Ask: "What's the public interface, and which seams should we test?"

## Anti-patterns

- **Implementation-coupled** — mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological** — the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth — a known-good literal, a worked example, the spec.
- **Horizontal slicing** — writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead — one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Refactoring is not part of the loop.** It belongs to the review stage (see the `self-review` skill), not the red → green implementation cycle.
