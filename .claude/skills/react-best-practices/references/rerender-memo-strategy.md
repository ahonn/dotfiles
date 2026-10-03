# Re-render: Strategic memo()

**Priority**: HIGH
**Impact**: Render performance, UI responsiveness
**Applies to**: Component optimization

---

## Check the Existing Compiler Setup

> If [React Compiler](react-compiler.md) is configured, confirm the affected code is compiled before considering manual optimization. React version alone does not imply compilation. Keep existing memoization unless a focused change and verification justify its removal.

```javascript
// With React Compiler - just write simple code
function Parent() {
  const [count, setCount] = useState(0);
  const items = expensiveSort(data);
  const handleClick = (id) => selectItem(id);

  return <ExpensiveList items={items} onClick={handleClick} />;
}
// Verify compilation coverage and the affected interaction
```

**Without Compiler, or for code it does not compile**: Use the strategies below only when evidence shows a useful optimization. A re-render alone does not establish a performance problem.

---

## When to Use memo()

### Good Candidates

1. **Expensive components** - Large subtrees, complex calculations
2. **Frequently re-rendering parents** - Parent state changes often
3. **Same props pattern** - Props don't change every render

```javascript
// Good: Expensive list with stable props
const ExpensiveList = memo(function ExpensiveList({ items, onSelect }) {
  return (
    <ul>
      {items.map(item => (
        <ComplexItem key={item.id} item={item} onSelect={onSelect} />
      ))}
    </ul>
  );
});
```

### Bad Candidates

1. **Leaf components** - No children, minimal render cost
2. **Always-new props** - Props change every render anyway
3. **Simple components** - Memoization overhead > render cost

```javascript
// Bad: Simple leaf component
const SimpleText = memo(function SimpleText({ text }) {
  return <span>{text}</span>; // Memoization overhead not worth it
});

// Bad: Props always change
const AlwaysNew = memo(function AlwaysNew({ data }) {
  // If data is a new object every render, memo is useless
  return <div>{data.value}</div>;
});
```

---

## Complete Pattern

For memo to work, props must be stable:

```javascript
function Parent() {
  const [count, setCount] = useState(0);
  const [items, setItems] = useState([]);

  // Stable callback with useCallback
  const handleSelect = useCallback((id) => {
    setItems(prev => prev.map(item =>
      item.id === id ? { ...item, selected: true } : item
    ));
  }, []);

  // Stable computed value with useMemo
  const sortedItems = useMemo(() =>
    [...items].sort((a, b) => a.name.localeCompare(b.name)),
    [items]
  );

  return (
    <>
      <button onClick={() => setCount(c => c + 1)}>
        Count: {count}
      </button>
      {/* Won't re-render when count changes */}
      <ExpensiveList items={sortedItems} onSelect={handleSelect} />
    </>
  );
}

const ExpensiveList = memo(function ExpensiveList({ items, onSelect }) {
  console.log('ExpensiveList rendered');
  return items.map(item => (
    <ExpensiveItem key={item.id} item={item} onSelect={onSelect} />
  ));
});
```

---

## useMemo for Derived Data

```javascript
function SearchResults({ items, query }) {
  // Expensive filtering/sorting - memoize
  const filteredItems = useMemo(() => {
    return items
      .filter(item => item.name.includes(query))
      .sort((a, b) => a.score - b.score);
  }, [items, query]);

  return <List items={filteredItems} />;
}
```

### When NOT to Use useMemo

```javascript
// Unnecessary: Simple computation
const doubled = useMemo(() => count * 2, [count]);
// Just use: const doubled = count * 2;

// Unnecessary: Creating JSX (React already optimizes this)
const element = useMemo(() => <div>{text}</div>, [text]);
// Just use: <div>{text}</div>
```

---

## useCallback for Stable Functions

```javascript
function Parent() {
  const [items, setItems] = useState([]);

  // Stable function reference
  const handleDelete = useCallback((id) => {
    setItems(prev => prev.filter(item => item.id !== id));
  }, []); // No deps - setItems is stable

  // Unstable - recreated every render
  const handleDeleteBad = (id) => {
    setItems(prev => prev.filter(item => item.id !== id));
  };

  return <MemoizedList items={items} onDelete={handleDelete} />;
}
```

### When NOT to Use useCallback

```javascript
// Unnecessary: Not passed to memoized component
function Form() {
  const handleSubmit = () => { ... }; // Fine without useCallback
  return <form onSubmit={handleSubmit}>...</form>;
}

// Unnecessary: Dependencies change every render anyway
const handleClick = useCallback(() => {
  doSomething(data); // If data changes every render, useCallback is useless
}, [data]);
```

---

## Profiling Before Optimizing

**Don't guess - measure:**

```javascript
// React DevTools Profiler
// 1. Open React DevTools
// 2. Go to Profiler tab
// 3. Record interactions
// 4. Look for:
//    - Components that re-render unnecessarily
//    - Long render times

// Console logging (development only)
const ExpensiveComponent = memo(function ExpensiveComponent(props) {
  console.log('ExpensiveComponent rendered', props);
  // ...
});
```

---

## Custom Comparison

```javascript
const MemoizedComponent = memo(
  function MyComponent({ user, settings }) {
    return <div>{user.name} - {settings.theme}</div>;
  },
  (prevProps, nextProps) => {
    // Compare every value used by this component.
    return (
      prevProps.user.name === nextProps.user.name &&
      prevProps.settings.theme === nextProps.settings.theme
    );
  }
);
```

**Warning**: Custom comparison can be error-prone. Prefer stable props instead.

---

## Related Rules

- [react-compiler.md](react-compiler.md) - Compiler applicability and adoption
- [rerender-context-splitting.md](rerender-context-splitting.md)
