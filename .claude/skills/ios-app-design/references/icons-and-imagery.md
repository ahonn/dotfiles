# Icons & Imagery

SF Symbols, app icons, and image handling for iOS.

## SF Symbols (Primary Icon System)

SF Symbols is Apple's icon library — 6,000+ symbols designed to integrate with San Francisco font.

### Usage
```swift
// Basic symbol
Image(systemName: "heart.fill")

// In a label (icon + text, adapts to context)
Label("Favorites", systemImage: "heart.fill")

// With rendering mode
Image(systemName: "heart.fill")
    .symbolRenderingMode(.hierarchical)

// With size matching text
Image(systemName: "heart.fill")
    .font(.title)
```

### Rendering Modes
| Mode | Effect | Use |
|------|--------|-----|
| `.monochrome` | Single color | Simple UI icons |
| `.hierarchical` | Primary + secondary opacity layers | Depth without multiple colors |
| `.palette` | Developer-defined colors per layer | Brand-colored icons |
| `.multicolor` | Apple-defined colors | Weather, file types, flags |

### Symbol Effects (iOS 17+)
```swift
Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative)  // Animated

Image(systemName: "checkmark.circle")
    .symbolEffect(.bounce, value: isComplete)  // Bounce on change
```

### Symbol Variants
- Use `.fill` for selected/active states (tab bar selected)
- Use outlined for unselected/inactive states
- Consistent across all icons in a context

## App Icons

### iOS 26 Liquid Glass Icons
Multi-layer icons rendered with Liquid Glass material:
- **Back layer**: Background color/pattern
- **Front layer**: Foreground symbol/logo
- Rendered with specular highlights and refraction
- Must work in: light, dark, tinted, clear appearances

### Design with Icon Composer
Apple's tool for creating multi-layer app icons:
1. Create foreground element (simple, recognizable silhouette)
2. Create background layer (color, gradient, or pattern)
3. Preview in all four appearances
4. Export for all required sizes

### Icon Guidelines
| Rule | Detail |
|------|--------|
| Shape | System applies rounded-rect mask — don't bake corners |
| Size | 1024×1024px source, system scales down |
| Padding | Keep content within ~80% of icon area |
| Simplicity | Recognizable at 29pt (smallest size) |
| No text | Unreadable at small sizes; use symbol instead |
| No photos | Abstract, symbolic representation |

## Image Handling

### Asset Catalog Best Practices
- Provide @1x, @2x, @3x for raster images
- Use PDF/SVG vector assets for resolution independence
- Set "Preserve Vector Data" for scaling above native size
- Provide light and dark variants for UI images

### Async Image Loading
```swift
AsyncImage(url: imageURL) { phase in
    switch phase {
    case .success(let image):
        image.resizable().aspectRatio(contentMode: .fill)
    case .failure:
        Image(systemName: "photo")
            .foregroundStyle(.tertiary)
    case .empty:
        ProgressView()
    @unknown default:
        EmptyView()
    }
}
```

### Image Performance
- Use `LazyImage` or equivalent for lists
- Set appropriate `resizable()` and `aspectRatio()` to avoid layout thrash
- Downsample large images to display size using `ImageRenderer` or `CGImageSource`
- Cache aggressively for network images

## Common Mistakes

- **Custom icon sets** when SF Symbols has equivalent — check SF Symbols app first
- **Inconsistent icon weight** — match SF Symbol weight to text weight in context
- **Icon-only buttons without labels** — add accessibility labels at minimum
- **Oversized icons** — icons should complement text, not dominate; match text style size
- **Rasterized app icons with baked corners** — system applies mask; provide square source
