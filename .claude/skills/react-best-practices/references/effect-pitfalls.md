# Effect Pitfalls: You Might Not Need an Effect

Effects are an escape hatch for synchronizing with external systems. Most "effects" in codebases are unnecessary and cause performance issues.

## Decision Tree

```
Need to run code?
├── Responding to user event?
│   └── Use event handler, NOT effect
├── Calculating derived data?
│   └── Calculate during render, NOT effect + state
├── Expensive calculation?
│   └── Use useMemo, NOT effect + state
├── Resetting state on prop change?
│   └── Use key prop, NOT effect
├── Adjusting state on prop change?
│   └── Calculate during render, NOT effect
└── Synchronizing with external system?
    └── ✅ Use effect (this is the valid use case)
```

## Anti-Pattern 1: Derived State

```javascript
// 🔴 Bad: effect + state for derived data
function Form() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [fullName, setFullName] = useState('');

  useEffect(() => {
    setFullName(firstName + ' ' + lastName);
  }, [firstName, lastName]);
}

// ✅ Good: calculate during render
function Form() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const fullName = firstName + ' ' + lastName; // Just compute it
}
```

**Why**: Effect causes extra render cycle. Derived data should be computed, not stored.

## Anti-Pattern 2: Expensive Calculations

```javascript
// 🔴 Bad: effect + state
function TodoList({ todos, filter }) {
  const [visibleTodos, setVisibleTodos] = useState([]);

  useEffect(() => {
    setVisibleTodos(filterTodos(todos, filter));
  }, [todos, filter]);
}

// ✅ Good: useMemo (only if actually expensive)
function TodoList({ todos, filter }) {
  const visibleTodos = useMemo(
    () => filterTodos(todos, filter),
    [todos, filter]
  );
}

// ✅ Better: just compute (if not expensive)
function TodoList({ todos, filter }) {
  const visibleTodos = filterTodos(todos, filter);
}
```

**Tip**: Use `console.time()` to measure. If < 1ms, don't memoize.

## Anti-Pattern 3: Resetting State on Prop Change

```javascript
// 🔴 Bad: effect to reset state
function ProfilePage({ userId }) {
  const [comment, setComment] = useState('');

  useEffect(() => {
    setComment('');
  }, [userId]);
}

// ✅ Good: use key to remount
function ProfilePage({ userId }) {
  return <Profile userId={userId} key={userId} />;
}

function Profile({ userId }) {
  const [comment, setComment] = useState(''); // Fresh state per userId
}
```

## Anti-Pattern 4: Adjusting State on Prop Change

```javascript
// 🔴 Bad: effect to adjust state
function List({ items }) {
  const [selection, setSelection] = useState(null);

  useEffect(() => {
    if (selection && !items.includes(selection)) {
      setSelection(null);
    }
  }, [items, selection]);
}

// ✅ Good: calculate during render
function List({ items }) {
  const [selectedId, setSelectedId] = useState(null);
  const selection = items.find(item => item.id === selectedId) ?? null;
}
```

## Anti-Pattern 5: Event Logic in Effect

```javascript
// 🔴 Bad: effect for user action response
function ProductPage({ productId }) {
  const [purchased, setPurchased] = useState(false);

  useEffect(() => {
    if (purchased) {
      showNotification('Purchased!');
      sendAnalytics('purchase', productId);
    }
  }, [purchased, productId]);

  function handleBuy() {
    setPurchased(true);
  }
}

// ✅ Good: logic in event handler
function ProductPage({ productId }) {
  function handleBuy() {
    sendAnalytics('purchase', productId);
    showNotification('Purchased!');
    // Update state if needed for UI
  }
}
```

**Rule**: If you know exactly what triggered the action, handle it in the event handler.

## Anti-Pattern 6: Initializing from Props

```javascript
// 🔴 Bad: effect to initialize
function Dropdown({ options }) {
  const [selected, setSelected] = useState(null);

  useEffect(() => {
    setSelected(options[0]);
  }, []);
}

// ✅ Good: initialize directly
function Dropdown({ options }) {
  const [selected, setSelected] = useState(options[0]);
}

// ✅ Or use lazy initializer for expensive init
function Dropdown({ options }) {
  const [selected, setSelected] = useState(() => computeDefault(options));
}
```

## Valid Effect Use Cases

Effects ARE needed for:

1. **External subscriptions**
   ```javascript
   useEffect(() => {
     const sub = store.subscribe(handleChange);
     return () => sub.unsubscribe();
   }, []);
   ```

2. **DOM manipulation outside React**
   ```javascript
   useEffect(() => {
     const map = new MapWidget(ref.current);
     return () => map.destroy();
   }, []);
   ```

3. **Data fetching** (though prefer framework solutions)
   ```javascript
   useEffect(() => {
     let ignore = false;
     fetchData(id).then(data => {
       if (!ignore) setData(data);
     });
     return () => { ignore = true; };
   }, [id]);
   ```

4. **Logging/Analytics on mount**
   ```javascript
   useEffect(() => {
     logPageView(url);
   }, [url]);
   ```

## Quick Checklist

Before writing an effect, ask:

- [ ] Can I calculate this from props/state during render?
- [ ] Is this responding to a user event? → Use event handler
- [ ] Am I setting state based on other state? → Compute instead
- [ ] Am I syncing with something outside React? → Effect is correct
