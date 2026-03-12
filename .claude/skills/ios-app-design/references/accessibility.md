# Accessibility

VoiceOver, Dynamic Type, contrast, and inclusive design for iOS.

## Non-Negotiable Requirements

These are not optional. Apps failing these may be rejected or receive poor reviews.

### 1. Dynamic Type Support
All text must scale with user's preferred text size. See [typography.md](typography.md).

### 2. VoiceOver
Every meaningful UI element must be accessible to screen readers.

```swift
// Label for non-text elements
Image("profile")
    .accessibilityLabel("User profile photo")

// Combine related elements
HStack {
    Text("Price")
    Text("$9.99")
}
.accessibilityElement(children: .combine)

// Custom actions
ItemRow(item)
    .accessibilityAction(.delete) { deleteItem(item) }

// Hide decorative elements
Image("decorative-divider")
    .accessibilityHidden(true)
```

### 3. Color Contrast
| Text Type | Minimum Ratio (WCAG AA) |
|-----------|------------------------|
| Body text (<18pt) | 4.5:1 |
| Large text (≥18pt bold, ≥24pt regular) | 3:1 |
| UI components & graphics | 3:1 |

### 4. Touch Targets
- Minimum 44 × 44pt tap area for all interactive elements
- Expand hit area without changing visual size:

```swift
Button(action: {}) {
    Image(systemName: "xmark")
        .font(.caption)
}
.frame(minWidth: 44, minHeight: 44)
```

## Accessibility Traits

```swift
Text("Section Header")
    .accessibilityAddTraits(.isHeader)

Button("Play") { }
    .accessibilityAddTraits(.startsMediaSession)

Toggle("Airplane Mode", isOn: $airplane)
    // Toggle trait is automatic for Toggle

// Announce state changes
.accessibilityValue(isPlaying ? "Playing" : "Paused")
```

## Reduce Motion

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// Provide non-animated alternative
if reduceMotion {
    content.transition(.opacity)
} else {
    content.transition(.slide)
}
```

## Reduce Transparency

```swift
@Environment(\.accessibilityReduceTransparency) var reduceTransparency

// Provide solid background when transparency is reduced
.background(reduceTransparency ? Color(.systemBackground) : .ultraThinMaterial)
```

## Increase Contrast

```swift
@Environment(\.colorSchemeContrast) var contrast

// Adjust colors for high contrast mode
.foregroundStyle(contrast == .increased ? .primary : .secondary)
```

## Bold Text

When the user enables Bold Text in Settings, all system text styles automatically become bolder. Custom fonts should also respond:

```swift
@Environment(\.legibilityWeight) var weight

.fontWeight(weight == .bold ? .bold : .regular)
```

## Testing Checklist

### Accessibility Inspector (Xcode)
- [ ] All interactive elements have labels
- [ ] Logical focus order (top-to-bottom, left-to-right)
- [ ] No orphaned elements (accessible but invisible)
- [ ] Headers properly marked for navigation

### VoiceOver Testing (on device)
- [ ] Navigate entire flow with VoiceOver
- [ ] All actions achievable without sight
- [ ] Announcements make sense in sequence
- [ ] Custom gestures have VoiceOver alternatives

### Dynamic Type Testing
- [ ] Test at Default, xLarge, and AX5 (largest)
- [ ] No text truncation that hides critical info
- [ ] Layout adapts (stack vertically if needed)
- [ ] Scrollable when content exceeds screen

### Color Testing
- [ ] Works in light mode, dark mode, high contrast
- [ ] Information not conveyed by color alone
- [ ] Test with color filters (Settings → Accessibility → Display)

## Common Mistakes

- **Decorative images not hidden** — background images, dividers should be `.accessibilityHidden(true)`
- **Redundant labels** — button titled "Close" doesn't need label "Close button"
- **Missing state announcements** — toggle changes, loading states should announce
- **Custom gestures without alternatives** — provide buttons or accessibility actions
- **Images of text** — use actual text; images don't scale with Dynamic Type
