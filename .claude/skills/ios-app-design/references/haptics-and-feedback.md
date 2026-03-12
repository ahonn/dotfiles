# Haptics & Feedback

Haptic Engine patterns and user feedback mechanisms for iOS.

## Haptic Feedback Types

### UIImpactFeedbackGenerator
Physical impact sensations — something collided or landed.

```swift
// Light — subtle, small elements
let light = UIImpactFeedbackGenerator(style: .light)
light.impactOccurred()

// Medium — standard interactions
let medium = UIImpactFeedbackGenerator(style: .medium)
medium.impactOccurred()

// Heavy — significant, large elements
let heavy = UIImpactFeedbackGenerator(style: .heavy)
heavy.impactOccurred()

// Soft — gentle, cushioned feel
let soft = UIImpactFeedbackGenerator(style: .soft)
soft.impactOccurred()

// Rigid — sharp, precise feel
let rigid = UIImpactFeedbackGenerator(style: .rigid)
rigid.impactOccurred()
```

### UISelectionFeedbackGenerator
Selection changes — scrolling through options.

```swift
let selection = UISelectionFeedbackGenerator()
selection.selectionChanged()
// Use for: picker scrolling, segment changes, option cycling
```

### UINotificationFeedbackGenerator
Outcome feedback — success, warning, error.

```swift
let notification = UINotificationFeedbackGenerator()
notification.notificationOccurred(.success)  // Task completed
notification.notificationOccurred(.warning)  // Attention needed
notification.notificationOccurred(.error)    // Action failed
```

## SwiftUI Sensory Feedback (iOS 17+)

```swift
Button("Submit") { submit() }
    .sensoryFeedback(.success, trigger: isSubmitted)

Toggle("Setting", isOn: $isOn)
    .sensoryFeedback(.selection, trigger: isOn)

// Impact on gesture
    .sensoryFeedback(.impact(weight: .medium), trigger: dragEnded)
```

## When to Use Haptics

### DO Use Haptics For
| Action | Type |
|--------|------|
| Toggle switch | `.selection` or light impact |
| Pull-to-refresh threshold | Medium impact |
| Action completed (save, send) | `.success` notification |
| Destructive action confirmed | `.warning` notification |
| Error / failed action | `.error` notification |
| Snap to grid / alignment | Light impact |
| Picker value change | `.selection` |
| Long press activation | Medium impact |
| Drag threshold crossed | Soft impact |

### DON'T Use Haptics For
- Every single button tap (overwhelming)
- Scrolling (system handles this for paging)
- Background events the user didn't initiate
- Continuous animations or loops
- Rapid successive events (feels like vibration, not feedback)

## Performance

```swift
// Prepare the generator before use for zero-latency response
let generator = UIImpactFeedbackGenerator(style: .medium)
generator.prepare()  // Warm up the Taptic Engine

// ... user interaction happens ...
generator.impactOccurred()
```

## Visual Feedback Complement

Haptics should always accompany visual feedback, never replace it:
- Button press → visual depression + haptic
- Success → checkmark animation + success haptic
- Error → shake animation + error haptic
- Selection → highlight change + selection haptic
