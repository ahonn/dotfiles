---
name: ios-app-design
description: Design or review iOS navigation, layout, accessibility, and system materials using the project's target OS and UI framework.
user-invocable: true
---

# iOS App Design

Choose interface behavior that fits the product, target OS, and existing UI framework. Inspect deployment targets and current components before proposing new APIs or visual-system adoption.

## Design Criteria

- Use familiar system navigation and controls when they support the task. Preserve established product behavior unless a redesign is requested.
- Keep content readable and actions reachable across supported sizes, orientations, text sizes, and appearances.
- Include accessibility semantics, sufficient contrast, and reduced-motion behavior appropriate to the interaction.
- Give immediate feedback for actions. Distinguish motion polish from actual rendering, network, or input latency.
- Treat Liquid Glass adoption as a compatibility and design decision. Do not replace opaque backgrounds or custom controls merely to match a newer OS style; consider readability, accessibility settings, and the requested scope.
- Apply SwiftUI, UIKit, and React Native examples only within the matching implementation environment. Verify version-sensitive APIs against installed tooling and official Apple documentation before use.

## Read by Decision

| Decision | Reference |
|----------|-----------|
| Adopting or tuning Liquid Glass materials | [Liquid Glass](references/liquid-glass.md) |
| Choosing tabs, navigation stacks, modals, or search | [Navigation](references/navigation.md) |
| Safe areas, adaptive layout, or iPad presentation | [Layout](references/layout.md) |
| Text hierarchy and Dynamic Type | [Typography](references/typography.md) |
| Semantic colors, contrast, or theme behavior | [Color and theme](references/color-and-theme.md) |
| Symbols, imagery, or app icons | [Icons and imagery](references/icons-and-imagery.md) |
| Transitions, springs, or gesture continuity | [Motion](references/motion.md) |
| VoiceOver, contrast, and accessibility settings | [Accessibility](references/accessibility.md) |
| Haptic and visual feedback | [Haptics and feedback](references/haptics-and-feedback.md) |

Read only references relevant to the current decision. Their examples and preferred values are starting points, not universal adoption requirements.

## Completion

For implementation, inspect the affected interface in the available runtime and check relevant interaction and accessibility states. Use the global test policy; do not add logic tests for visual polish alone.

For review, separate observable usability or accessibility defects from aesthetic suggestions. Report what was inspected and any device or OS coverage gaps; do not claim visual verification from source inspection.
