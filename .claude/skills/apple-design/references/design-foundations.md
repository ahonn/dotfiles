# Design Foundations

Use these principles to reason about the requested interaction, not as a mandatory
checklist or a reason to redesign unrelated surfaces.

## Purpose, control, and familiarity

- Purpose: spend attention on the task people came to accomplish. Decorative effects
  should earn their cost through comprehension or appropriate expression.
- Agency: provide cancel, undo, or recovery where meaningful. Product confirmations
  should match the consequence of the action; avoid routine friction.
- Responsibility: make privacy, consent, and consequences understandable at the
  relevant moment. Prefer concrete safeguards over generic disclaimers.
- Familiarity: preserve platform conventions and established product patterns.
  Intentional exceptions need a reason grounded in the user's task.
- Flexibility: adapt to input methods, screen sizes, language, and accessibility
  needs. Offer configuration where one arrangement cannot serve important contexts.
- Simplicity: prioritize the common path without hiding necessary context. Fewer
  visible controls do not automatically mean an easier interface.
- Craft: align typography, color, icons, spacing, feedback, and motion so the
  interaction remains coherent through its edge cases.
- Delight: choose the appropriate emotional tone through the whole experience.
  It need not mean added celebration or playful motion.

## Spatial relationships and feedback

Enter and exit paths should communicate a coherent relationship. Returning a panel
toward its source is often predictable; a different destination can be correct when
the action itself moves the object there. For a scaling anchored overlay, use an
origin tied to its source. Centered surfaces and fades need different treatment.

During a gesture, intermediate motion should hint at the destination or available
outcome. Preserve continuity when an interaction reverses; use a spring or retargeted
transition as appropriate rather than mechanically mirroring every easing curve.

Make status, completion, warnings, and errors understandable. Place controls near
their effects and group related content. Navigation should reveal location, available
destinations, and how to leave. Specific labels help when they clarify content, but
do not rename established navigation solely because a generic label exists.

## Sound and haptics

Combine motion, sound, and haptics only when they support a meaningful event:

1. Causality: make clear which action produced the feedback.
2. Coordination: align feedback closely enough to feel like one event; use the
   platform's supported APIs and account for device latency.
3. Utility: reserve feedback for useful moments such as completion, commitment,
   errors, or snapping. Respect user settings and avoid repetitive noise.

Web vibration support is not equivalent to native Apple haptics. Do not prescribe
an unsupported browser API to reproduce a native experience or rely on sound or
haptics as the only way to communicate state.

## Prototyping and evaluation

A small interactive prototype helps when gesture behavior or visual hierarchy is
uncertain. It is optional for straightforward changes. Design interaction and visuals
together so motion expresses an actual state relationship.

Evaluate with realistic content, affected input methods, and accessibility settings.
Use normal playback to judge responsiveness and slow playback to locate discontinuity.
Test with representative users or real devices when the decision warrants it and
they are available; disclose limitations without blocking unrelated progress.
