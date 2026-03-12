# Typography

San Francisco type system, Dynamic Type, and text styling for iOS.

## San Francisco Font Family

Apple's system font, optimized for every screen size:

| Variant | Use |
|---------|-----|
| SF Pro | Default UI text |
| SF Pro Rounded | Playful, friendly contexts |
| SF Pro Display | Large titles (20pt+) — automatic |
| SF Pro Text | Body text (<20pt) — automatic |
| SF Mono | Code, tabular data |
| SF Compact | Smaller contexts (watchOS, widgets) |
| New York | Serif, editorial/reading contexts |

## Dynamic Type (CRITICAL)

**All text must support Dynamic Type.** Users set their preferred text size in Settings; your app must respect it.

### Text Styles (Always Use These)
```swift
Text("Title")
    .font(.largeTitle)    // 34pt default, scales

Text("Body text")
    .font(.body)          // 17pt default, scales

Text("Caption")
    .font(.caption)       // 12pt default, scales
```

### Full Scale (Default Sizes)
| Style | Default Size | Weight |
|-------|-------------|--------|
| `.largeTitle` | 34pt | Regular |
| `.title` | 28pt | Regular |
| `.title2` | 22pt | Regular |
| `.title3` | 20pt | Regular |
| `.headline` | 17pt | Semibold |
| `.body` | 17pt | Regular |
| `.callout` | 16pt | Regular |
| `.subheadline` | 15pt | Regular |
| `.footnote` | 13pt | Regular |
| `.caption` | 12pt | Regular |
| `.caption2` | 11pt | Regular |

### Custom Fonts with Dynamic Type
```swift
// Scale custom font with Dynamic Type
Text("Custom")
    .font(.custom("MyFont", size: 17, relativeTo: .body))
```

### Accessibility Sizes
- Users can enable even larger sizes in Accessibility settings
- Test with the largest Dynamic Type size
- Use `ScrollView` for content that might overflow

## iOS 26 Typography Changes

- **Bolder weights** in key moments (alerts, onboarding)
- **Left-aligned** by default, improving scanability
- Navigation titles use refined Liquid Glass styling

## Text Hierarchy

Build clear hierarchy with weight and size, not color:

```swift
VStack(alignment: .leading, spacing: 4) {
    Text("Section Title")
        .font(.headline)
    Text("Supporting description that provides context")
        .font(.subheadline)
        .foregroundStyle(.secondary)
}
```

### Weight Progression
- **Title**: `.title` or `.largeTitle`, regular or bold
- **Heading**: `.headline` (semibold by default)
- **Body**: `.body`, regular weight
- **Secondary**: `.subheadline` or `.footnote`, `.secondary` color
- **Tertiary**: `.caption`, `.tertiary` color

## Common Mistakes

- **Fixed font sizes** — Always use text styles or `.relativeTo:` for Dynamic Type
- **Too many weights** — Stick to 2-3 weights maximum in a view
- **Low contrast secondary text** — Use `.secondary` foreground style, not custom gray
- **Truncation without reason** — Prefer text wrapping; truncate only when space is genuinely limited
- **Custom fonts without scaling** — Always bind to a text style with `relativeTo:`
- **Thin/ultralight for body** — Hard to read; use regular or medium weight
