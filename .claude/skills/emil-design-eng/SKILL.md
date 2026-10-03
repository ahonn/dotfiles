---
name: emil-design-eng
description: Refine web component feedback and motion when implementing or polishing a specific interaction.
---

# Design Engineering

Apply Emil Kowalski's design engineering approach to the requested component. Make
feedback immediate, preserve spatial relationships, and handle interaction edge
cases without burdening the user. Begin with the task; do not return a readiness
message or require a fixed review format.

## Working approach

1. Inspect the component, existing design tokens, input methods, and lifecycle.
2. Identify the user benefit of motion: feedback, state change, orientation, or
   explanation. Repeated interactions need less ceremony and must remain usable.
3. Improve the smallest relevant surface. Prefer existing primitives and the
   product's motion language before introducing another library or abstraction.
4. Check rapid reversal, repeated input, varying content, and reduced motion where
   relevant. Report what was inspected or observed and what remains unverified.

Treat timings, curves, scales, and effects as starting points to tune, not universal
pass/fail rules. A fade, built-in easing, static state change, or deliberate layout
animation can be appropriate. Do not infer poor performance from syntax alone or
add motion solely to satisfy a checklist.

## Read only the relevant reference

- Choosing whether and how to animate, timing, easing, springs, or stagger:
  [Motion decisions](references/motion-decisions.md).
- Building buttons, tooltips, overlays, toasts, clipped reveals, or other CSS motion:
  [Web component patterns](references/web-components.md).
- Investigating frame drops, reduced motion, touch hover, or visual verification:
  [Performance and accessibility](references/performance-accessibility.md).

These implementation references target the web. For React Native or native UI,
carry over interaction principles only; use the target platform's animation,
gesture, and accessibility APIs. Use `apple-design` when continuous gesture physics
is the central problem, and `review-animations` for an explicitly requested motion
audit. Do not load those skills merely because this file mentions them.

## Completion

Explain the visible improvement, cite affected code when reviewing, and disclose
device or visual checks that could not be performed. Separate confirmed defects
from stylistic alternatives. Follow the task's test mode rather than adding tests
for purely visual tuning.
