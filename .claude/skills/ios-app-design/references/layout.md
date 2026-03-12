# Layout & Spacing

Safe areas, spatial rhythm, adaptive layout for all Apple devices.

## Safe Areas

### Always Respect Safe Areas
Content must never be clipped by the notch, Dynamic Island, home indicator, or rounded corners.

```swift
// Content automatically respects safe areas in SwiftUI
ScrollView {
    content
}

// Extend background to edges while keeping content safe
ZStack {
    Color.blue.ignoresSafeArea()
    VStack {
        // Content stays in safe area
    }
}
```

### When to Ignore Safe Areas
- **Backgrounds and fills** — extend to screen edges
- **Full-bleed images** — visual content behind status bar
- **Never for interactive elements** — buttons, text inputs must stay in safe area

## Spacing System

### Apple's Spacing Values (Points)
| Use | Value |
|-----|-------|
| Minimum tap spacing | 8pt |
| Tight grouping | 8pt |
| Standard spacing | 16pt |
| Section spacing | 20pt |
| Large section gap | 32pt |
| Screen edge margin | 16pt (iPhone), 20pt (iPad) |

### Touch Targets
- **Minimum**: 44 × 44pt for all tappable elements
- Even if visually smaller, the tap area must be at least 44pt
- Use `.contentShape(Rectangle())` to expand hit area

## Adaptive Layout

### Device Classes
| Device | Width Class | Height Class |
|--------|-------------|--------------|
| iPhone Portrait | Compact | Regular |
| iPhone Landscape | Compact (small) / Regular (Plus/Max) | Compact |
| iPad Portrait | Regular | Regular |
| iPad Landscape | Regular | Regular |

### Responsive Patterns
```swift
// Adapt layout to size class
@Environment(\.horizontalSizeClass) var sizeClass

var body: some View {
    if sizeClass == .compact {
        // Stack vertically on iPhone
        VStack { content }
    } else {
        // Side by side on iPad
        HStack { content }
    }
}

// ViewThatFits — automatic best-fit layout
ViewThatFits {
    HStack { content }  // Try horizontal first
    VStack { content }  // Fall back to vertical
}
```

### iPad-Specific
- Use `NavigationSplitView` for multi-column
- Support multitasking (Split View, Slide Over)
- Don't just scale up iPhone layout — redesign for the space
- Consider pointer/keyboard input

## Layout Components

### Lists
```swift
// Grouped list (most common iOS pattern)
List {
    Section("General") {
        // rows
    }
    Section("Advanced") {
        // rows
    }
}
.listStyle(.insetGrouped)
```

### Grids
```swift
// Adaptive grid that fills available space
LazyVGrid(columns: [
    GridItem(.adaptive(minimum: 160))
], spacing: 16) {
    ForEach(items) { item in
        CardView(item: item)
    }
}
```

### Scroll Views
- Use `LazyVStack` / `LazyHStack` for long lists (lazy loading)
- `ScrollView` does NOT have lazy loading by default
- Add `.scrollIndicators(.hidden)` only when appropriate
- Support pull-to-refresh: `.refreshable { await reload() }`

## Common Mistakes

- **Fixed pixel layouts** — Always use points, never pixels; support Dynamic Type
- **Ignoring landscape** — At minimum, ensure nothing breaks
- **Hardcoded widths** — Use flexible layouts, `.frame(maxWidth: .infinity)`
- **Ignoring iPad** — At least provide a reasonable two-column layout
- **Content under home indicator** — Bottom content needs safe area padding
