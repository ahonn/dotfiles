# Rendering: Hoist Static JSX

**Priority**: MEDIUM
**Impact**: Avoids unnecessary re-creation
**Applies to**: Static elements, Loading states, Icons, SVGs

---

## The Problem

JSX inside components is recreated every render:

```javascript
// Bad: Creates new JSX element on every render
function Container({ loading, children }) {
  const skeleton = <div className="animate-pulse h-20 bg-gray-200" />

  return (
    <div>
      {loading ? skeleton : children}
    </div>
  )
}
```

---

## Solution: Hoist Static JSX

Move static elements outside the component:

```javascript
// Good: Same element reused across renders
const skeleton = <div className="animate-pulse h-20 bg-gray-200" />

function Container({ loading, children }) {
  return (
    <div>
      {loading ? skeleton : children}
    </div>
  )
}
```

---

## Common Patterns

### Pattern 1: Loading Skeletons

```javascript
// Hoist static skeleton
const loadingSkeleton = (
  <div className="space-y-4">
    <div className="h-4 bg-gray-200 rounded w-3/4" />
    <div className="h-4 bg-gray-200 rounded w-1/2" />
  </div>
)

function Card({ loading, content }) {
  if (loading) return loadingSkeleton
  return <div>{content}</div>
}
```

### Pattern 2: Static Icons/SVGs

```javascript
// Especially helpful for large SVGs
const checkIcon = (
  <svg viewBox="0 0 24 24" className="w-5 h-5">
    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
  </svg>
)

const errorIcon = (
  <svg viewBox="0 0 24 24" className="w-5 h-5 text-red-500">
    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10..." />
  </svg>
)

function StatusIcon({ status }) {
  return status === 'success' ? checkIcon : errorIcon
}
```

### Pattern 3: Empty States

```javascript
const emptyState = (
  <div className="text-center py-12">
    <p className="text-gray-500">No items found</p>
  </div>
)

function List({ items }) {
  if (items.length === 0) return emptyState

  return (
    <ul>
      {items.map(item => <li key={item.id}>{item.name}</li>)}
    </ul>
  )
}
```

---

## When NOT to Hoist

### When Props Are Needed

```javascript
// Can't hoist - needs dynamic className
function Badge({ count, variant }) {
  return (
    <span className={`badge badge-${variant}`}>
      {count}
    </span>
  )
}
```

### When Using Hooks

```javascript
// Can't hoist - uses hooks
function AnimatedIcon() {
  const [isHovered, setIsHovered] = useState(false)
  return (
    <svg
      onMouseEnter={() => setIsHovered(true)}
      className={isHovered ? 'scale-110' : ''}
    >
      ...
    </svg>
  )
}
```

### When Context Matters

```javascript
// Can't hoist - depends on context
function ThemedIcon() {
  const theme = useTheme()
  return <svg fill={theme.iconColor}>...</svg>
}
```

---

## Performance Impact

Hoisting static JSX:
- Avoids object allocation on every render
- Keeps same reference (helps with memo)
- Most impactful for large/complex static elements (SVGs)

For simple elements (`<span>text</span>`), the benefit is minimal.

---

## Alternative: memo for Static Components

If hoisting isn't possible, use memo:

```javascript
const Skeleton = memo(function Skeleton() {
  return <div className="animate-pulse h-20 bg-gray-200" />
})

function Container({ loading, children }) {
  return (
    <div>
      {loading ? <Skeleton /> : children}
    </div>
  )
}
```

---

## Summary

| Scenario | Approach |
|----------|----------|
| Pure static JSX (no props) | Hoist outside component |
| Static structure, dynamic props | memo() the component |
| Dynamic content | Keep inside component |

---

## Related Rules

- [rerender-memo-strategy.md](rerender-memo-strategy.md)
