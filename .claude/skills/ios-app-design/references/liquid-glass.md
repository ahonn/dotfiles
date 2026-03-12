# Liquid Glass

iOS 26's signature design material — translucent, refractive, dynamic.

## Core Concepts

Liquid Glass is a multi-layered translucent material that:
- **Reflects** light and surroundings with specular highlights
- **Refracts** content behind it, creating depth
- **Adapts** dynamically to context, scrolling state, and background

## Where Liquid Glass Appears

### System-Managed (automatic)
- Tab bars and toolbars
- Navigation bars
- Control Center
- Lock Screen time display
- Dock and Home Screen icons
- Widgets
- Alerts and action sheets

### Developer-Applied
- Custom controls and surfaces via `.glassEffect` modifier
- App icons via multi-layer design in Icon Composer

## SwiftUI Adoption

### Using System Components (Preferred)
System components automatically adopt Liquid Glass in iOS 26. Most apps need zero changes for basic adoption:

```swift
// Tab bars, toolbars, navigation bars — automatic
TabView {
    ContentView()
        .tabItem { Label("Home", systemImage: "house") }
}
```

### Custom Glass Surfaces
```swift
// Apply Liquid Glass to custom views
MyCustomControl()
    .glassEffect(.regular)

// Glass effect with tint
MyWidget()
    .glassEffect(.regular.tint(Color.blue))
```

### Glass Effect Variants
- `.regular` — Standard translucent glass
- `.clear` — More transparent, less frosted
- `.thin` — Subtle, lightweight glass

## Adoption Strategy

### Step 1: Remove Custom Chrome
- Delete custom background colors from navigation bars and tab bars
- Remove opaque toolbar backgrounds
- Let system defaults take over

### Step 2: Audit Custom Controls
- Identify elements that use solid backgrounds for emphasis
- Replace with `.glassEffect` where appropriate
- Ensure text contrast is maintained over variable backgrounds

### Step 3: App Icon Update
- Use Icon Composer to create multi-layer icons
- Design for light, dark, tinted, and clear appearances
- Front layer: foreground element
- Back layer: background fill or pattern

### Step 4: Test Thoroughly
- Test over light AND dark wallpapers
- Test with high contrast accessibility setting
- Verify readability in all scroll states
- Check Dynamic Island / notch interactions

## Common Pitfalls

- **Low contrast text** — Glass backgrounds vary; use semantic text colors that adapt
- **Double glass** — Don't layer glass on glass; it becomes muddy and illegible
- **Overuse** — Not every surface needs glass; use for navigation and controls, not content areas
- **Ignoring dark mode** — Glass renders differently; test both appearances

## Timeline

- iOS 26: Liquid Glass introduced, opt-in for custom elements
- iOS 27: Apple will remove the option to retain pre-Liquid Glass designs — adoption is mandatory
