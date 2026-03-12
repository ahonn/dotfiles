# Motion & Animation

iOS animation principles, spring physics, and transition patterns.

## Core Principle

Motion in iOS should feel **physical and purposeful**. Every animation should answer: what changed, why, and where did it go?

## Spring Animations (Default in iOS)

iOS uses spring physics as the default animation curve. Springs feel natural because they model real-world physical behavior.

```swift
// Default spring (recommended starting point)
withAnimation(.spring()) {
    isExpanded.toggle()
}

// Customized spring
withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
    isVisible = true
}

// Snappy spring (quick, minimal bounce)
withAnimation(.snappy) {
    selectedTab = newTab
}

// Bouncy spring (playful, more overshoot)
withAnimation(.bouncy) {
    isDropped = true
}
```

### Spring Parameters
| Parameter | Effect |
|-----------|--------|
| `duration` | How long the animation takes to settle |
| `bounce` | 0 = no bounce, 0.5 = moderate, 1.0 = very bouncy; negative = overdamped |

### When to Use Each
| Context | Spring Type |
|---------|-------------|
| Navigation transitions | `.default` (system-managed) |
| Toggle / expand-collapse | `.snappy` or `.spring(duration: 0.35)` |
| Drag release | `.spring(bounce: 0.3)` |
| Playful UI (onboarding, celebration) | `.bouncy` |
| Subtle state change | `.spring(duration: 0.2, bounce: 0)` |

## Transition Patterns

### View Transitions
```swift
// Matched geometry for seamless morph
@Namespace var namespace

// In list
Image(item.image)
    .matchedGeometryEffect(id: item.id, in: namespace)

// In detail
Image(item.image)
    .matchedGeometryEffect(id: item.id, in: namespace)
```

### Built-in Transitions
```swift
// Appear / disappear
if isVisible {
    ContentView()
        .transition(.opacity)               // Fade
        .transition(.slide)                  // Slide from edge
        .transition(.move(edge: .bottom))    // Move from specific edge
        .transition(.scale.combined(with: .opacity))  // Scale + fade
}
```

### Navigation Transitions (iOS 18+)
```swift
NavigationStack {
    ListView()
        .navigationTransition(.zoom(sourceID: item.id, in: namespace))
}
```

## Phase Animations
```swift
// Multi-phase animation
PhaseAnimator([false, true]) { phase in
    Image(systemName: "heart.fill")
        .scaleEffect(phase ? 1.2 : 1.0)
        .foregroundStyle(phase ? .red : .pink)
}
```

## Reduce Motion (CRITICAL)

Always respect the Reduce Motion accessibility setting.

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

withAnimation(reduceMotion ? .none : .spring()) {
    isExpanded.toggle()
}

// Or use crossfade as alternative
if isVisible {
    content
        .transition(reduceMotion ? .opacity : .slide)
}
```

## Performance Guidelines

### DO
- Animate `opacity` and `transform` (scale, offset, rotation) — GPU-accelerated
- Use `drawingGroup()` for complex view hierarchies during animation
- Keep animations under 0.5s for UI interactions (0.2-0.35s is ideal)
- Use `withAnimation` block to batch related changes

### DON'T
- Animate layout properties (frame size, padding) — causes layout recalculation
- Use `Timer` for animations — use SwiftUI animation system
- Create animations longer than 1s for UI interactions (feels sluggish)
- Animate on every frame without `Canvas` or `TimelineView`
- Use linear easing for UI — feels robotic; use springs

## iOS 26 Motion Updates

- Tab bar shrink/expand uses fluid spring animation
- Liquid Glass refraction animates with content scroll
- System transitions refined with matched geometry principles
- Glass morphing effects on control state changes
