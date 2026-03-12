---
name: ios-app-design
description: "iOS app design guidelines based on Apple HIG and iOS 26 Liquid Glass. Use when: (1) Designing iOS app interfaces, (2) Reviewing iOS UI code, (3) Building SwiftUI/UIKit views, (4) Adopting Liquid Glass design, (5) Creating app icons. Triggers on: iOS design, SwiftUI layout, tab bar, navigation bar, Liquid Glass, SF Symbols, Dynamic Type, safe area, app icon, HIG."
user-invocable: true
---

# iOS App Design Guidelines

Apple Human Interface Guidelines + iOS 26 Liquid Glass design system reference.

## Quick Reference (Priority Order)

### CRITICAL - Must Follow

| Rule | Impact | Reference |
|------|--------|-----------|
| Liquid Glass adoption | Visual consistency with iOS 26 | [liquid-glass.md](references/liquid-glass.md) |
| Navigation patterns | Usability, platform conventions | [navigation.md](references/navigation.md) |
| Safe areas & layout | Content visibility, device compat | [layout.md](references/layout.md) |
| Accessibility | Inclusivity, App Store compliance | [accessibility.md](references/accessibility.md) |

### HIGH - Strongly Recommended

| Rule | Impact | Reference |
|------|--------|-----------|
| Typography & Dynamic Type | Readability, user preference | [typography.md](references/typography.md) |
| Color system & themes | Visual coherence, dark mode | [color-and-theme.md](references/color-and-theme.md) |
| SF Symbols & icons | Platform-native feel | [icons-and-imagery.md](references/icons-and-imagery.md) |

### MEDIUM - Recommended

| Rule | Impact | Reference |
|------|--------|-----------|
| Motion & animation | Polish, perceived performance | [motion.md](references/motion.md) |
| Haptics & feedback | Tactile experience | [haptics-and-feedback.md](references/haptics-and-feedback.md) |

---

## iOS 26 Liquid Glass - Key Principles

Three foundational pillars of iOS 26's design system:

### 1. Content Leads
Controls float above content using translucent glass layers. Content is never obscured by opaque chrome. The UI recedes; the user's content advances.

### 2. Concentricity
UI elements echo the rounded geometry of Apple hardware — rounded corners, circular buttons, pill shapes. Software and hardware share a unified visual rhythm.

### 3. Fluid Responsiveness
Elements dynamically adapt: tab bars shrink on scroll, glass refracts surrounding colors, controls morph contextually. Nothing is static.

---

## Quick Decision Tree

```
iOS Design Issue?
├── Building navigation?
│   ├── Top-level sections → Tab Bar (≤5 tabs)
│   ├── Hierarchical drill-down → NavigationStack
│   ├── Focused task / decision → Modal (.sheet, .fullScreenCover)
│   └── Secondary actions → Toolbar items
├── Adopting Liquid Glass?
│   ├── Tab bar / toolbar → Use system defaults, remove custom backgrounds
│   ├── Custom controls → Apply .glassEffect modifier
│   ├── App icon → Use Icon Composer, multi-layer design
│   └── Existing solid chrome → Replace with system materials
├── Typography choices?
│   ├── Body text → San Francisco, support Dynamic Type
│   ├── Display / title → SF Pro Rounded or system serif
│   └── Fixed-size text → Almost never correct, justify carefully
├── Color decisions?
│   ├── Semantic colors → Use system colors (label, secondaryLabel, etc.)
│   ├── Brand accent → Tint color, one dominant hue
│   ├── Backgrounds → System background + materials, not hardcoded
│   └── Dark mode → Must work; use adaptive colors
├── Layout issues?
│   ├── Content clipped → Check safe area insets
│   ├── Landscape broken → Use GeometryReader / adaptive layout
│   └── iPad / large screen → Use NavigationSplitView, responsive columns
├── Accessibility?
│   ├── Text too small → Support Dynamic Type (all text categories)
│   ├── Low contrast → Check against WCAG AA (4.5:1 body, 3:1 large)
│   ├── VoiceOver → Add accessibility labels, traits, hints
│   └── Reduce Motion → Provide alternative to animations
└── Performance feel?
    ├── Janky scrolling → Lazy containers, async image loading
    ├── Slow transitions → Use matched geometry, spring animations
    └── Unresponsive taps → Haptic feedback, immediate visual response
```

---

## Design Aesthetics for iOS

### DO
- **Embrace depth and translucency** — Liquid Glass, vibrancy, materials
- **Use system components** — they automatically adopt Liquid Glass
- **Design for multiple appearances** — light, dark, tinted, high contrast
- **Let content breathe** — generous spacing, clear hierarchy
- **Use SF Symbols** — consistent with system, support Dynamic Type scaling
- **Design for touch** — minimum 44pt tap targets
- **Use platform idioms** — swipe-to-delete, pull-to-refresh, long press menus

### DON'T
- **Don't fight the platform** — custom tab bars that break expected behavior
- **Don't use opaque chrome** — solid navigation bars feel dated in iOS 26
- **Don't ignore Dynamic Type** — fixed font sizes break accessibility
- **Don't hardcode colors** — use semantic system colors for theme adaptation
- **Don't replicate Android/web patterns** — hamburger menus, FABs, bottom sheets as primary nav
- **Don't over-customize** — heavy custom styling that loses Liquid Glass coherence
- **Don't use thin/ultralight fonts for body** — San Francisco is optimized at regular/medium weights
- **Don't put critical actions in hard-to-reach areas** — bottom of screen is easier than top for one-handed use

---

## Reference Files

| File | Content |
|------|---------|
| [liquid-glass.md](references/liquid-glass.md) | Liquid Glass material, modifiers, adoption strategy |
| [navigation.md](references/navigation.md) | Tab bars, navigation stacks, modals, search |
| [layout.md](references/layout.md) | Safe areas, spacing, adaptive layout, iPad |
| [typography.md](references/typography.md) | San Francisco, Dynamic Type, text styles |
| [color-and-theme.md](references/color-and-theme.md) | System colors, dark mode, materials, vibrancy |
| [icons-and-imagery.md](references/icons-and-imagery.md) | SF Symbols, app icons, Icon Composer |
| [motion.md](references/motion.md) | Spring animations, transitions, matched geometry |
| [accessibility.md](references/accessibility.md) | VoiceOver, Dynamic Type, contrast, Reduce Motion |
| [haptics-and-feedback.md](references/haptics-and-feedback.md) | Haptic engine, feedback patterns |

**Search rules**: `grep -l "keyword" references/`
