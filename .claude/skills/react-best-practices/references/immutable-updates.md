# Immutable Update Patterns

React state must be treated as immutable. Never mutate objects or arrays directly.

## Array Operations Quick Reference

| Operation | ❌ Mutates | ✅ Returns New |
|-----------|-----------|----------------|
| Add | `push`, `unshift` | `[...arr, item]`, `concat` |
| Remove | `pop`, `shift`, `splice` | `filter`, `slice` |
| Replace | `arr[i] = x`, `splice` | `map` |
| Sort | `sort`, `reverse` | `toSorted`, `toReversed`, `[...arr].sort()` |

## Array Patterns

### Add Item

```javascript
// ❌ Mutates
items.push(newItem);

// ✅ Spread (end)
setItems([...items, newItem]);

// ✅ Spread (beginning)
setItems([newItem, ...items]);

// ✅ Insert at index
setItems([
  ...items.slice(0, index),
  newItem,
  ...items.slice(index)
]);
```

### Remove Item

```javascript
// ❌ Mutates
items.splice(index, 1);

// ✅ Filter by condition
setItems(items.filter(item => item.id !== idToRemove));

// ✅ Filter by index
setItems(items.filter((_, i) => i !== index));
```

### Update Item

```javascript
// ❌ Mutates
items[index].done = true;

// ✅ Map to new array
setItems(items.map(item =>
  item.id === id ? { ...item, done: true } : item
));

// ✅ Map by index
setItems(items.map((item, i) =>
  i === index ? { ...item, done: true } : item
));
```

### Sort/Reverse

```javascript
// ❌ Mutates
items.sort((a, b) => a.name.localeCompare(b.name));

// ✅ ES2023+ (non-mutating)
const sorted = items.toSorted((a, b) => a.name.localeCompare(b.name));

// ✅ Copy first
const sorted = [...items].sort((a, b) => a.name.localeCompare(b.name));
setItems(sorted);
```

## Object Patterns

### Update Property

```javascript
// ❌ Mutates
user.name = 'New Name';

// ✅ Spread
setUser({ ...user, name: 'New Name' });
```

### Update Nested Property

```javascript
// ❌ Mutates
user.address.city = 'Tokyo';

// ✅ Spread at each level
setUser({
  ...user,
  address: {
    ...user.address,
    city: 'Tokyo'
  }
});
```

### Update Deeply Nested

```javascript
// ❌ Mutates
state.users[0].profile.settings.theme = 'dark';

// ✅ Spread all the way down (verbose but correct)
setState({
  ...state,
  users: state.users.map((user, i) =>
    i !== 0 ? user : {
      ...user,
      profile: {
        ...user.profile,
        settings: {
          ...user.profile.settings,
          theme: 'dark'
        }
      }
    }
  )
});
```

**Tip**: If updates are this deep, consider flattening state structure. See [state-structure.md](state-structure.md).

## Common Mistakes

### Mistake 1: Array Methods That Mutate

```javascript
// ❌ These mutate the original array
items.push(x);      // Use: [...items, x]
items.pop();        // Use: items.slice(0, -1)
items.shift();      // Use: items.slice(1)
items.unshift(x);   // Use: [x, ...items]
items.splice(i, 1); // Use: items.filter((_, idx) => idx !== i)
items.sort();       // Use: [...items].sort() or items.toSorted()
items.reverse();    // Use: [...items].reverse() or items.toReversed()
```

### Mistake 2: Forgetting Nested Spread

```javascript
// ❌ Only spreads top level - nested object still shared
const newUser = { ...user };
newUser.address.city = 'Tokyo'; // Mutates original!

// ✅ Spread nested objects too
const newUser = {
  ...user,
  address: { ...user.address, city: 'Tokyo' }
};
```

### Mistake 3: Mutating Then Setting State

```javascript
// ❌ Mutation happens before setState
const newItems = items;
newItems.push(item); // Mutates original!
setItems(newItems);

// ✅ Create new reference
setItems([...items, item]);
```

## Using Immer (Optional)

Immer lets you write "mutating" code that produces immutable updates:

```javascript
import { useImmer } from 'use-immer';

function TodoList() {
  const [todos, updateTodos] = useImmer([]);

  function addTodo(title) {
    updateTodos(draft => {
      draft.push({ id: Date.now(), title, done: false });
    });
  }

  function toggleTodo(id) {
    updateTodos(draft => {
      const todo = draft.find(t => t.id === id);
      todo.done = !todo.done; // "Mutates" draft, but Immer handles it
    });
  }
}
```

**When to use Immer**:
- Deeply nested state updates
- Complex array manipulations
- Team prefers mutation-style syntax

**When to skip Immer**:
- Simple/shallow state
- Want to keep bundle small
- Team comfortable with spread patterns
