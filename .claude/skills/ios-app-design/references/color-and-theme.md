# Color & Theme

System colors, dark mode, materials, and vibrancy in iOS.

## System Colors (Semantic)

Always prefer semantic colors — they adapt to light/dark mode and accessibility settings automatically.

### Labels
| Color | Use |
|-------|-----|
| `.primary` | Primary text and icons |
| `.secondary` | Secondary text, subtitles |
| `.tertiary` | Tertiary text, disabled states |
| `.quaternary` | Minimal emphasis, placeholders |

### Backgrounds
| Color | Use |
|-------|-----|
| `.background` | Primary background |
| `.secondarySystemBackground` | Grouped content background |
| `.tertiarySystemBackground` | Content within grouped sections |

### System Accent Colors
| Color | Hex (Light) |
|-------|-------------|
| `.blue` | #007AFF |
| `.green` | #34C759 |
| `.red` | #FF3B30 |
| `.orange` | #FF9500 |
| `.yellow` | #FFCC00 |
| `.purple` | #AF52DE |
| `.pink` | #FF2D55 |
| `.indigo` | #5856D6 |
| `.teal` | #5AC8FA |

### Using Semantic Colors
```swift
Text("Title")
    .foregroundStyle(.primary)

Text("Subtitle")
    .foregroundStyle(.secondary)

// Tint color for interactive elements
Button("Action") { }
    .tint(.blue)
```

## Dark Mode (MANDATORY)

Every iOS app must support dark mode. Using semantic colors handles most cases automatically.

### Testing Checklist
- [ ] All text readable in both modes
- [ ] Images/icons adapt (use template rendering or provide dark variants)
- [ ] Custom colors have dark mode alternatives
- [ ] No hardcoded white/black that breaks in opposite mode

### Custom Adaptive Colors
```swift
// In Asset Catalog: set "Any" and "Dark" appearances
// Or programmatically:
extension Color {
    static let customBackground = Color("CustomBackground")  // Asset catalog
}

// UIKit dynamic color
let dynamicColor = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
        ? UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1)
        : UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
}
```

## Materials & Vibrancy

### System Materials (iOS 26 Liquid Glass era)
```swift
// Blur material backgrounds
VStack { content }
    .background(.ultraThinMaterial)
    .background(.thinMaterial)
    .background(.regularMaterial)
    .background(.thickMaterial)
    .background(.ultraThickMaterial)
```

### Vibrancy
Text and symbols over materials should use vibrancy to remain legible:
```swift
Text("Over blur")
    .foregroundStyle(.secondary)  // Automatically vibrant over materials
```

## iOS 26 Tinted Mode

iOS 26 adds a "tinted" icon/widget appearance. Design for four modes:
1. **Light** — Standard light appearance
2. **Dark** — Standard dark appearance
3. **Tinted** — Monochrome with user-chosen tint
4. **Clear** — Transparent Liquid Glass

## Color Best Practices

### DO
- Use semantic system colors for all standard UI elements
- Define a single **tint color** as your app's accent
- Tint your neutrals toward your brand hue for subtle cohesion
- Use `.opacity()` to create lighter variants rather than new color definitions
- Test colors with Color Contrast Analyzer (WCAG AA: 4.5:1 body, 3:1 large text)

### DON'T
- Hardcode `Color.white` / `Color.black` — use `.background` / `.primary`
- Use pure `#000000` or `#FFFFFF` — always slightly tint
- Create rainbow palettes — limit to 1-2 accent colors + neutrals
- Use color as the only signifier — add icons, labels, or patterns for colorblind users
- Ignore Increase Contrast accessibility setting
