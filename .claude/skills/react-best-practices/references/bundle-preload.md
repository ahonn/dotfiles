# Bundle: Preload on User Intent

**Priority**: CRITICAL
**Impact**: Perceived latency reduction
**Applies to**: Heavy components, Dynamic imports, User interactions

---

## The Problem

Dynamic imports reduce initial bundle size but add latency when the user triggers them.

```javascript
// User clicks button → waits for Monaco (~300KB) to load
function EditorButton({ onClick }) {
  return <button onClick={onClick}>Open Editor</button>
}
```

---

## Solution: Preload on Hover/Focus

Start loading before the user clicks:

```javascript
function EditorButton({ onClick }) {
  const preload = () => {
    if (typeof window !== 'undefined') {
      void import('./monaco-editor')
    }
  }

  return (
    <button
      onMouseEnter={preload}
      onFocus={preload}
      onClick={onClick}
    >
      Open Editor
    </button>
  )
}
```

---

## Patterns

### Pattern 1: Link Preloading

```javascript
function NavLink({ href, children }) {
  const preload = () => {
    // Preload the route's component
    void import(`./pages${href}`)
  }

  return (
    <Link
      href={href}
      onMouseEnter={preload}
      onFocus={preload}
    >
      {children}
    </Link>
  )
}
```

### Pattern 2: Prefetch with next/link

```javascript
// Next.js prefetches on viewport intersection by default
<Link href="/dashboard" prefetch={true}>
  Dashboard
</Link>

// Disable for rarely-visited pages
<Link href="/settings" prefetch={false}>
  Settings
</Link>
```

### Pattern 3: Manual Prefetch Hook

```javascript
function usePrefetch(importFn) {
  const prefetched = useRef(false)

  const prefetch = useCallback(() => {
    if (!prefetched.current) {
      prefetched.current = true
      void importFn()
    }
  }, [importFn])

  return prefetch
}

// Usage
const prefetchEditor = usePrefetch(() => import('./monaco-editor'))
<button onMouseEnter={prefetchEditor}>Open Editor</button>
```

### Pattern 4: Intersection Observer Preload

```javascript
function usePrefetchOnVisible(importFn) {
  const ref = useRef(null)
  const prefetched = useRef(false)

  useEffect(() => {
    const observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting && !prefetched.current) {
        prefetched.current = true
        void importFn()
      }
    })

    if (ref.current) observer.observe(ref.current)
    return () => observer.disconnect()
  }, [importFn])

  return ref
}

// Preload when element becomes visible
const ref = usePrefetchOnVisible(() => import('./heavy-component'))
<div ref={ref}>...</div>
```

---

## Best Practices

| Trigger | Use Case |
|---------|----------|
| `onMouseEnter` | Desktop hover |
| `onFocus` | Keyboard navigation, accessibility |
| `onTouchStart` | Mobile touch |
| Intersection Observer | Below-the-fold content |

**Combine multiple triggers for best coverage:**

```javascript
<button
  onMouseEnter={preload}
  onFocus={preload}
  onTouchStart={preload}
>
  Open
</button>
```

---

## Related Rules

- [bundle-dynamic-import.md](bundle-dynamic-import.md)
