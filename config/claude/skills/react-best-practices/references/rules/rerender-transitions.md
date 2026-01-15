# Re-render: Transitions for Non-Urgent Updates

**Priority**: MEDIUM
**Impact**: UI responsiveness, Input latency
**Applies to**: Frequent updates, Search filtering, Large list updates

---

## The Problem

Frequent state updates can block urgent UI updates:

```javascript
// Bad: Every scroll event blocks the main thread
function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)

  useEffect(() => {
    const handler = () => setScrollY(window.scrollY)
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])

  return <div>Scroll: {scrollY}</div>
}
```

---

## Solution: startTransition

Mark non-urgent updates as transitions:

```javascript
import { startTransition, useState } from 'react'

function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)

  useEffect(() => {
    const handler = () => {
      startTransition(() => {
        setScrollY(window.scrollY)
      })
    }
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])

  return <div>Scroll: {scrollY}</div>
}
```

---

## Common Use Cases

### 1. Search Input with Results

```javascript
function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])

  const handleChange = (e) => {
    const value = e.target.value
    // Urgent: Update input immediately
    setQuery(value)

    // Non-urgent: Filter results can wait
    startTransition(() => {
      setResults(filterItems(value))
    })
  }

  return (
    <>
      <input value={query} onChange={handleChange} />
      <ResultsList results={results} />
    </>
  )
}
```

### 2. Tab Switching with Heavy Content

```javascript
function TabContainer() {
  const [activeTab, setActiveTab] = useState('home')

  const switchTab = (tab) => {
    startTransition(() => {
      setActiveTab(tab)
    })
  }

  return (
    <>
      <TabBar activeTab={activeTab} onSwitch={switchTab} />
      <TabContent tab={activeTab} />
    </>
  )
}
```

### 3. Live Filtering Large Lists

```javascript
function FilterableList({ items }) {
  const [filter, setFilter] = useState('')
  const [filteredItems, setFilteredItems] = useState(items)

  const handleFilter = (value) => {
    setFilter(value) // Urgent

    startTransition(() => {
      setFilteredItems(
        items.filter(item =>
          item.name.toLowerCase().includes(value.toLowerCase())
        )
      )
    })
  }

  return (
    <>
      <input
        value={filter}
        onChange={(e) => handleFilter(e.target.value)}
        placeholder="Filter..."
      />
      <List items={filteredItems} />
    </>
  )
}
```

---

## useTransition Hook

For tracking pending state:

```javascript
import { useTransition, useState } from 'react'

function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleChange = (e) => {
    setQuery(e.target.value)

    startTransition(() => {
      setResults(filterItems(e.target.value))
    })
  }

  return (
    <>
      <input value={query} onChange={handleChange} />
      {isPending && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

---

## useDeferredValue Alternative

For values you don't control:

```javascript
import { useDeferredValue, useState } from 'react'

function SearchResults({ query }) {
  // Creates a "lagging" version of query
  const deferredQuery = useDeferredValue(query)
  const isStale = query !== deferredQuery

  const results = useMemo(
    () => filterItems(deferredQuery),
    [deferredQuery]
  )

  return (
    <div style={{ opacity: isStale ? 0.7 : 1 }}>
      <ResultsList results={results} />
    </div>
  )
}
```

---

## When to Use

| Scenario | Solution |
|----------|----------|
| You control the setState | `startTransition` |
| Need pending indicator | `useTransition` |
| Value comes from props | `useDeferredValue` |
| Urgent UI update | Don't use transitions |

---

## Don't Use Transitions For

```javascript
// Bad: User input should be immediate
startTransition(() => {
  setInputValue(e.target.value) // Don't do this
})

// Bad: Critical UI state
startTransition(() => {
  setIsModalOpen(true) // Don't delay modal opening
})
```

---

## Related Rules

- [rerender-memo-strategy.md](rerender-memo-strategy.md)
- [rerender-context-splitting.md](rerender-context-splitting.md)
