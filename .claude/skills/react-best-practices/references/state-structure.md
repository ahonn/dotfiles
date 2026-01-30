# State Structure Principles

Five principles for structuring React state to avoid bugs and simplify updates.

## The 5 Principles

| Principle | Problem It Solves |
|-----------|-------------------|
| Group related state | Forgetting to update together |
| Avoid contradictions | Impossible states |
| Avoid redundant state | Out-of-sync derived data |
| Avoid duplication | Multiple sources of truth |
| Avoid deep nesting | Complex update logic |

---

## 1. Group Related State

```javascript
// 🔴 Bad: separate but always updated together
const [x, setX] = useState(0);
const [y, setY] = useState(0);

function handleMove(e) {
  setX(e.clientX);
  setY(e.clientY); // Easy to forget one
}

// ✅ Good: grouped
const [position, setPosition] = useState({ x: 0, y: 0 });

function handleMove(e) {
  setPosition({ x: e.clientX, y: e.clientY });
}
```

**When to group**: If two values always change together.

---

## 2. Avoid Contradictions

```javascript
// 🔴 Bad: can be in impossible state (both true)
const [isSending, setIsSending] = useState(false);
const [isSent, setIsSent] = useState(false);

async function handleSubmit() {
  setIsSending(true);
  await send();
  setIsSending(false);
  setIsSent(true); // What if this throws before setIsSending(false)?
}

// ✅ Good: single status, impossible states are impossible
const [status, setStatus] = useState('idle'); // 'idle' | 'sending' | 'sent'

async function handleSubmit() {
  setStatus('sending');
  await send();
  setStatus('sent');
}
```

**Rule**: If states are mutually exclusive, use a single state with union type.

---

## 3. Avoid Redundant State

```javascript
// 🔴 Bad: fullName is redundant
const [firstName, setFirstName] = useState('');
const [lastName, setLastName] = useState('');
const [fullName, setFullName] = useState(''); // Derived!

// ✅ Good: compute during render
const [firstName, setFirstName] = useState('');
const [lastName, setLastName] = useState('');
const fullName = firstName + ' ' + lastName;
```

**Test**: Can you compute this from other state/props? → Don't store it.

---

## 4. Avoid Duplication

```javascript
// 🔴 Bad: selectedItem duplicates data from items
const [items, setItems] = useState([...]);
const [selectedItem, setSelectedItem] = useState(items[0]);

function handleUpdate(id, newTitle) {
  setItems(items.map(item =>
    item.id === id ? { ...item, title: newTitle } : item
  ));
  // 🔴 Must also update selectedItem if it's the one being edited!
  if (selectedItem.id === id) {
    setSelectedItem({ ...selectedItem, title: newTitle });
  }
}

// ✅ Good: store ID, derive the item
const [items, setItems] = useState([...]);
const [selectedId, setSelectedId] = useState(items[0].id);

const selectedItem = items.find(item => item.id === selectedId);

function handleUpdate(id, newTitle) {
  setItems(items.map(item =>
    item.id === id ? { ...item, title: newTitle } : item
  ));
  // selectedItem updates automatically!
}
```

**Pattern**: Store IDs, not objects. Derive objects from the source array.

---

## 5. Avoid Deep Nesting

```javascript
// 🔴 Bad: deeply nested, hard to update
const [plan, setPlan] = useState({
  places: [
    { id: 1, title: 'Paris', childPlaces: [
      { id: 2, title: 'Louvre', childPlaces: [...] }
    ]}
  ]
});

// Updating deeply nested item requires spreading all levels
function handleUpdate(id, newTitle) {
  setPlan({
    ...plan,
    places: plan.places.map(p1 => ({
      ...p1,
      childPlaces: p1.childPlaces.map(p2 =>
        p2.id === id ? { ...p2, title: newTitle } : p2
      )
    }))
  });
}

// ✅ Good: flat structure with references
const [places, setPlaces] = useState({
  1: { id: 1, title: 'Paris', childIds: [2] },
  2: { id: 2, title: 'Louvre', childIds: [] },
});

function handleUpdate(id, newTitle) {
  setPlaces({
    ...places,
    [id]: { ...places[id], title: newTitle }
  });
}
```

**Pattern**: Normalize like a database. Use IDs for relationships.

---

## Quick Decision Guide

```
Designing state?
├── Multiple values always change together?
│   └── Group into single state object
├── Values are mutually exclusive?
│   └── Use single state with union type
├── Can compute from other state/props?
│   └── Don't store, compute during render
├── Same data in multiple places?
│   └── Store ID, derive object
└── Deeply nested?
    └── Flatten with ID references
```

## State vs Props vs Derived

| Type | When to Use |
|------|-------------|
| **State** | Data that changes over time AND can't be computed |
| **Props** | Data passed from parent |
| **Derived** | Data computable from state/props → Just compute it |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Storing props in state | Use prop directly, or use `key` to reset |
| Storing computed values | Compute during render |
| Duplicating array items | Store IDs only |
| Multiple boolean flags | Single status union |
| Syncing state with useEffect | Compute or use key |
