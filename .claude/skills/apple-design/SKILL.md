---
name: apple-design
description: Apply Apple-inspired interaction principles when designing web gestures, interruptible springs, or translucent surfaces.
---

# Apple Design

Translate the interaction principles in Apple's design talks into the web:
immediate feedback, direct manipulation, continuity, predictable spatial
relationships, and accessible presentation. The references are adaptations and
tuning examples, not requirements Apple imposes on every interface.

## Working approach

1. Inspect the existing component and platform conventions. Identify what people
   manipulate, how it responds during input, and what happens at release or cancel.
2. Preserve control: feedback begins promptly, dragging tracks input, and reversible
   motion starts from its current visible position. Do not delay functional input
   to finish decorative motion.
3. Tune the requested behavior in context. Reuse the current gesture and animation
   stack; numeric parameters and APIs differ across libraries.
4. Verify relevant interruptions, boundaries, input modes, and accessibility
   settings. Distinguish code inspection from observed gesture feel.

## Read only the relevant reference

- Drag, flick, spring retargeting, velocity, snap points, or boundary resistance:
  [Gesture physics](references/gesture-physics.md).
- Translucency, depth, text over materials, optical sizing, or transparency settings:
  [Materials and typography](references/materials-typography.md).
- Spatial consistency, feedback, hierarchy, navigation, or interaction prototyping:
  [Design foundations](references/design-foundations.md).

Use general design principles across platforms, but do not translate CSS or Pointer
Events literally into React Native or SwiftUI. Native work should use native
gesture, spring, material, and accessibility APIs and platform-specific guidance.

For an ordinary web component timing or polish task, `emil-design-eng` is the more
focused entry point. Do not load both skills by default.

## Completion

Explain how the changed behavior preserves control or improves comprehension.
Report actual verification and any device limitations. Do not turn design
preferences, sample spring values, or an Apple aesthetic into mandatory findings.
