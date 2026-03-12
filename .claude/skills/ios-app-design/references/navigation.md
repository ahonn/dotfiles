# Navigation

iOS navigation patterns, conventions, and iOS 26 changes.

## Navigation Models

### Tab Bar (Top-Level Sections)
- **Use for**: 3-5 top-level content areas
- **Max tabs**: 5 on iPhone (more moves to "More" tab), flexible on iPad
- **iOS 26 behavior**: Floats above content with Liquid Glass; shrinks on scroll, expands on scroll-up
- **Icons**: Filled for selected state, outlined for unselected (SF Symbols automatic)

```swift
TabView {
    HomeView()
        .tabItem { Label("Home", systemImage: "house") }
    SearchView()
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
    ProfileView()
        .tabItem { Label("Profile", systemImage: "person") }
}
```

**DO**: Keep tab labels short (1-2 words), use recognizable SF Symbols
**DON'T**: Use more than 5 tabs, hide primary navigation behind gestures

### NavigationStack (Hierarchical)
- **Use for**: Drilling into detail from a list or collection
- **Back button**: System-managed, shows previous screen title
- **Large title**: Collapses to inline on scroll

```swift
NavigationStack {
    List(items) { item in
        NavigationLink(item.title) {
            DetailView(item: item)
        }
    }
    .navigationTitle("Items")
}
```

### NavigationSplitView (iPad / Large Screens)
- **Use for**: Multi-column layouts on iPad, Mac Catalyst
- **Columns**: Sidebar → Content → Detail

```swift
NavigationSplitView {
    SidebarView()
} content: {
    ContentListView()
} detail: {
    DetailView()
}
```

### Modal Presentations
- **Use for**: Focused tasks requiring completion or cancellation
- **Types**:
  - `.sheet` — Partial cover, swipe to dismiss
  - `.fullScreenCover` — Full screen, explicit dismiss required
  - `.alert` — Brief decisions
  - `.confirmationDialog` — Action sheets

**DO**: Use sheets for creation flows, settings, pickers
**DON'T**: Use modals for navigation — they interrupt flow

### Toolbar
- **Use for**: Contextual actions related to current content
- **Placement**: `.topBarTrailing`, `.bottomBar`, `.keyboard`
- **iOS 26**: Toolbar adopts Liquid Glass automatically

## iOS 26 Navigation Changes

| Element | Before iOS 26 | iOS 26 |
|---------|---------------|--------|
| Tab bar | Fixed at bottom, opaque/blur | Floating, Liquid Glass, shrinks on scroll |
| Nav bar | Blur material, solid tint | Liquid Glass, more translucent |
| Toolbar | Standard blur | Liquid Glass |
| Back button | Chevron + text | Refined Liquid Glass styling |

### Migration Checklist
- [ ] Remove `.toolbarBackground(.visible)` overrides
- [ ] Remove custom tab bar background colors
- [ ] Remove custom navigation bar appearances (UINavigationBarAppearance)
- [ ] Test with default system styles first
- [ ] Only customize if truly needed for brand identity

## Anti-Patterns

- **Hamburger menu** — Not an iOS pattern; use tab bar or sidebar
- **Custom bottom navigation** — Use system TabView, not custom reimplementation
- **Floating Action Button** — Android/Material pattern; use toolbar buttons or contextual menus
- **Nested navigation stacks** — Causes confusion; one NavigationStack at the root
- **Tab bar + bottom toolbar** — Don't stack two bottom bars
