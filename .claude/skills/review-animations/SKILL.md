---
name: review-animations
description: Audit animation and gesture changes for behavioral defects, accessibility, performance, and visual coherence.
disable-model-invocation: true
---

# Reviewing Animations

Review motion in the requested scope against a high craft bar. Follow the user's
requested review scope and output format; for a mixed review, apply this method to
the motion portion and use the appropriate method for the remaining code.

## Review method

1. Identify affected interactions, target platform, input modes, motion primitives,
   and existing product tokens. Inspect surrounding lifecycle code as needed.
2. Trace entry, exit, cancellation, reversal, repeated input, and cleanup. Check
   accessibility equivalents and whether motion delays functional input.
3. Observe the interaction when tools and runtime are available. Profile suspected
   rendering problems under representative load. Code inspection can prove a stale
   callback or missing cancellation path; it cannot establish subjective feel or
   actual dropped frames on its own.
4. Report the smallest useful findings with location, trigger, impact, evidence, and
   a concrete correction. Do not manufacture findings to earn an approval verdict.

## Standards with context

- Purpose and frequency: repeated actions should remain ready for immediate input.
  Keyboard-triggered motion is not automatically a defect.
- Response and timing: judge first feedback, readiness, and settling separately.
  Roughly 300 ms is a useful tuning reference for small UI, not a universal ceiling.
  Built-in easing, accelerating exits, and symmetric timings can be appropriate.
- Spatial coherence: scaling anchored overlays should communicate their source.
  Centered modals, fades, deliberate morphs, and icon effects have different needs;
  neither pure fade nor `scale(0)` is automatically a violation.
- Interruptibility: prove that reversal starts from a coherent visible state and
  that completion callbacks cannot corrupt newer state. Judge behavior rather than
  banning keyframes or assuming every spring preserves velocity.
- Rendering: prefer transform and opacity where they preserve intended behavior.
  Layout animation, clipping, blur, and library shorthand properties are investigation
  leads, not proof of poor performance. Check the installed version and target.
- Accessibility: honor the relevant platform's reduced-motion setting while keeping
  state changes, focus, and functionality intact. Static transitions are valid.
  Check touch, hover, and keyboard access where the changed interaction uses them.
- Cohesion: compare with surrounding product behavior. Blur, bounce, stagger,
  asymmetric timing, and custom curves are optional design choices.

CSS properties, browser compositing, media queries, and Pointer Events apply to web
implementations. Do not apply them directly to React Native, Reanimated, or SwiftUI;
inspect that platform's drivers, gesture lifecycle, and accessibility APIs instead.

## References

[STANDARDS.md](STANDARDS.md) routes to shared references by topic. Read only the
reference needed for the interaction or finding. Tuning values support reasoning;
they are not external requirements or substitutes for observed evidence.

## Report and verdict

Separate these categories, omitting empty ones:

- **Defects:** reproducible or code-provable failures, with severity proportional
  to user impact. Include file/line, trigger, evidence, and a targeted fix.
- **Design preferences:** alternatives that may improve feel or consistency; explain
  the tradeoff without treating a house-style preference as a blocking bug.
- **Needs visual verification:** an unresolved concern with a specific scenario and
  check. State which environment or observation is missing.

Lead with material findings and end with a scoped conclusion: block for established
material defects; approve when the inspected scope has no material findings; use a
qualified conclusion when essential visual or device evidence is unavailable.
State what was verified and what was not. Do not claim runtime verification from
source inspection or require a findings table when prose is clearer.

Choose remedies by the demonstrated problem: remove unnecessary delay, reduce
motion, correct lifecycle or origin, improve rendering, or add missing accessibility
handling. Treat accessibility defects according to impact, not as final cosmetic
polish. Do not add effects or rewrite unrelated components during a review unless
the user also requested implementation.
