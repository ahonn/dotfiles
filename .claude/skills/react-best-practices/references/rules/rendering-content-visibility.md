# Rendering: CSS content-visibility for Long Lists

**Priority**: MEDIUM
**Impact**: 10× faster initial render for long lists
**Applies to**: Chat messages, Feed items, Large tables

---

## The Problem

Long lists force browser to layout and paint all items:

```javascript
// 1000 messages = 1000 layout calculations on initial render
function MessageList({ messages }) {
  return (
    <div className="overflow-y-auto h-screen">
      {messages.map(msg => (
        <MessageItem key={msg.id} message={msg} />
      ))}
    </div>
  )
}
```

---

## Solution: content-visibility: auto

Tell browser to skip layout/paint for off-screen items:

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px; /* Estimated height */
}
```

```javascript
function MessageList({ messages }) {
  return (
    <div className="overflow-y-auto h-screen">
      {messages.map(msg => (
        <div key={msg.id} className="message-item">
          <Avatar user={msg.author} />
          <div>{msg.content}</div>
        </div>
      ))}
    </div>
  )
}
```

**Result**: Browser skips layout/paint for ~990 off-screen items.

---

## How It Works

1. `content-visibility: auto` - Browser skips rendering for off-screen elements
2. `contain-intrinsic-size` - Provides placeholder size to prevent layout shifts

```css
/* Basic usage */
.list-item {
  content-visibility: auto;
  contain-intrinsic-size: auto 100px;
}

/* With block size only (width auto) */
.list-item {
  content-visibility: auto;
  contain-intrinsic-block-size: 100px;
}
```

---

## Tailwind CSS

```javascript
// Add to tailwind.config.js
module.exports = {
  theme: {
    extend: {
      // Custom utilities if needed
    }
  }
}

// Usage with arbitrary values
<div className="[content-visibility:auto] [contain-intrinsic-size:0_80px]">
  {/* content */}
</div>
```

Or create a utility class:

```css
@layer utilities {
  .content-auto {
    content-visibility: auto;
    contain-intrinsic-size: 0 80px;
  }
}
```

---

## Best Practices

### 1. Set Accurate Intrinsic Size

```css
/* Too small = layout jumps when scrolling down */
.item { contain-intrinsic-size: 0 20px; } /* Bad if items are 100px */

/* Match actual size for best UX */
.item { contain-intrinsic-size: 0 100px; } /* Good */

/* Use 'auto' to remember rendered size */
.item { contain-intrinsic-size: auto 100px; } /* Better */
```

### 2. Apply to Direct Children

```css
/* Apply to each item, not the container */
.list-container {
  /* Don't put content-visibility here */
}

.list-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```

### 3. Combine with Virtualization for Extreme Cases

For 10,000+ items, combine with virtualization:

```javascript
import { FixedSizeList } from 'react-window'

function VirtualList({ items }) {
  return (
    <FixedSizeList
      height={600}
      itemCount={items.length}
      itemSize={80}
    >
      {({ index, style }) => (
        <div style={style} className="content-auto">
          <Item data={items[index]} />
        </div>
      )}
    </FixedSizeList>
  )
}
```

---

## Browser Support

| Browser | Support |
|---------|---------|
| Chrome | 85+ ✅ |
| Edge | 85+ ✅ |
| Firefox | 125+ ✅ |
| Safari | 18+ ✅ |

Progressive enhancement - older browsers render normally.

---

## When to Use

| List Size | Recommendation |
|-----------|----------------|
| < 50 items | Not needed |
| 50-500 items | `content-visibility: auto` |
| 500-5000 items | `content-visibility` + consider virtualization |
| > 5000 items | Virtualization (react-window, react-virtual) |

---

## Debugging

Chrome DevTools shows `content-visibility` status:

1. Open DevTools → Elements
2. Select element with `content-visibility`
3. Look for "Rendering" section
4. Check "content-visibility: auto" indicator

---

## Related

- [Virtualization with react-window](https://github.com/bvaughn/react-window)
- [Virtualization with @tanstack/react-virtual](https://tanstack.com/virtual/latest)
