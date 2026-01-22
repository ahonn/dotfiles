# React Hooks Deep Dive

Patterns and decision guides for React Hooks.

---

## useState vs useReducer

| Scenario | Use | Reason |
|----------|-----|--------|
| Single primitive | `useState` | Simple, direct |
| Object with 1-2 fields | `useState` | Spread updates manageable |
| Multiple related values | `useReducer` | Centralized logic |
| Complex state transitions | `useReducer` | Actions describe intent |
| Shared update logic | `useReducer` | Reducer is testable |

```javascript
// useState: simple cases
const [count, setCount] = useState(0);
setCount(prev => prev + 1);

// useReducer: complex cases
function reducer(state, action) {
  switch (action.type) {
    case 'increment': return { count: state.count + 1 };
    case 'reset': return { count: action.payload };
    default: throw new Error(`Unknown: ${action.type}`);
  }
}
const [state, dispatch] = useReducer(reducer, { count: 0 });
```

---

## useEffect Patterns

### Include All Reactive Values

```javascript
useEffect(() => {
  fetchData(userId, category);
}, [userId, category]); // Both required
```

### Object Dependencies → Destructure

```javascript
// Bad: runs every render
useEffect(() => { connect(options); }, [options]);

// Good: stable primitives
const { roomId, serverUrl } = options;
useEffect(() => { connect({ roomId, serverUrl }); }, [roomId, serverUrl]);
```

### Race Condition Prevention

```javascript
useEffect(() => {
  let ignore = false;
  async function load() {
    const result = await api.fetch(id);
    if (!ignore) setData(result);
  }
  load();
  return () => { ignore = true; };
}, [id]);
```

### Cleanup

```javascript
useEffect(() => {
  const sub = api.subscribe(id);
  return () => sub.unsubscribe();
}, [id]);
```

---

## Custom Hook Patterns

### Return Object (named values)

```javascript
function useWindowSize() {
  const [size, setSize] = useState({ width: 0, height: 0 });
  useEffect(() => {
    const handle = () => setSize({
      width: innerWidth, height: innerHeight
    });
    handle();
    addEventListener('resize', handle);
    return () => removeEventListener('resize', handle);
  }, []);
  return size;
}
```

### Return Array (positional values)

```javascript
function useToggle(initial = false) {
  const [value, setValue] = useState(initial);
  const toggle = useCallback(() => setValue(v => !v), []);
  return [value, toggle];
}
```

### Parameterized Hook

```javascript
function useDebounce(value, delay = 500) {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}
```

---

## Common Pitfalls

### 1. Stale Closure

```javascript
// Bug: count is stale
useEffect(() => {
  const timer = setInterval(() => setCount(count + 1), 1000);
  return () => clearInterval(timer);
}, []);

// Fix: use updater function
useEffect(() => {
  const timer = setInterval(() => setCount(c => c + 1), 1000);
  return () => clearInterval(timer);
}, []);
```

### 2. Object in Dependency Array

```javascript
// Bug: infinite loop
const options = { roomId };
useEffect(() => { connect(options); }, [options]);

// Fix: use primitives
useEffect(() => { connect({ roomId }); }, [roomId]);
```

### 3. Conditional Hooks

```javascript
// Bug: breaks rules of hooks
if (isLoggedIn) {
  const [user, setUser] = useState(null);
}

// Fix: always call, handle condition in usage
const [user, setUser] = useState(null);
```

### 4. Missing Cleanup

```javascript
// Bug: memory leak
useEffect(() => {
  addEventListener('resize', handleResize);
}, []);

// Fix: cleanup
useEffect(() => {
  addEventListener('resize', handleResize);
  return () => removeEventListener('resize', handleResize);
}, []);
```

---

## Hook Quick Reference

| Hook | Purpose | Returns |
|------|---------|---------|
| `useState` | Local state | `[value, setValue]` |
| `useReducer` | Complex state | `[state, dispatch]` |
| `useEffect` | Side effects | void |
| `useLayoutEffect` | Sync DOM reads | void |
| `useMemo` | Cached computation | memoized value |
| `useCallback` | Cached function | memoized function |
| `useRef` | Mutable ref | `{ current }` |
| `useContext` | Read context | context value |
| `useId` | Unique ID | string |
| `useTransition` | Non-blocking | `[isPending, startTransition]` |
| `useDeferredValue` | Deferred value | deferred copy |
