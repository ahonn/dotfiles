# JS: Set/Map for O(1) Lookups

**Priority**: MEDIUM
**Impact**: Algorithm efficiency, Large data handling
**Applies to**: Array operations, Data filtering, Membership checks

---

## The Problem

Array methods like `includes()`, `find()`, `indexOf()` are O(n):

```javascript
// O(n) per check - O(n*m) total for filtering
const allowedIds = ['a', 'b', 'c', ...]; // n items
const filtered = items.filter(item =>    // m items
  allowedIds.includes(item.id)           // O(n) each time
);
// Total: O(n * m)
```

---

## Solution: Use Set for O(1) Lookups

```javascript
// O(1) per check - O(m) total
const allowedIds = new Set(['a', 'b', 'c', ...]); // O(n) creation, once
const filtered = items.filter(item =>
  allowedIds.has(item.id)                         // O(1) each time
);
// Total: O(n + m) ≈ O(m) if n << m
```

---

## Common Patterns

### Array Membership Check

```javascript
// Bad: O(n) per check
const tags = ['react', 'typescript', 'nextjs'];
if (tags.includes(userTag)) { ... }

// Good: O(1) per check
const tags = new Set(['react', 'typescript', 'nextjs']);
if (tags.has(userTag)) { ... }
```

### Filtering with Allowlist/Blocklist

```javascript
// Bad
const blockedUsers = ['user1', 'user2', ...];
const allowed = users.filter(u => !blockedUsers.includes(u.id));

// Good
const blockedUsers = new Set(['user1', 'user2', ...]);
const allowed = users.filter(u => !blockedUsers.has(u.id));
```

### Deduplication

```javascript
// Bad: O(n²)
const unique = items.filter((item, index) =>
  items.findIndex(i => i.id === item.id) === index
);

// Good: O(n)
const seen = new Set();
const unique = items.filter(item => {
  if (seen.has(item.id)) return false;
  seen.add(item.id);
  return true;
});

// Best: If you just need unique values
const uniqueIds = [...new Set(items.map(i => i.id))];
```

---

## Use Map for Key-Value Lookups

### Building Index Maps

```javascript
// Bad: O(n) lookup per user
users.map(user => {
  const team = teams.find(t => t.id === user.teamId); // O(n)
  return { ...user, teamName: team?.name };
});
// Total: O(users * teams)

// Good: O(1) lookup per user
const teamMap = new Map(teams.map(t => [t.id, t]));
users.map(user => ({
  ...user,
  teamName: teamMap.get(user.teamId)?.name
}));
// Total: O(teams + users)
```

### Grouping

```javascript
// Bad: Multiple passes
const grouped = {
  active: items.filter(i => i.status === 'active'),
  pending: items.filter(i => i.status === 'pending'),
  done: items.filter(i => i.status === 'done')
};
// 3 passes through items

// Good: Single pass with Map
const grouped = new Map();
for (const item of items) {
  const group = grouped.get(item.status) ?? [];
  group.push(item);
  grouped.set(item.status, group);
}
// 1 pass through items
```

### Counting

```javascript
// Bad: Multiple filters
const activeCount = items.filter(i => i.status === 'active').length;
const pendingCount = items.filter(i => i.status === 'pending').length;

// Good: Single pass
const counts = new Map();
for (const item of items) {
  counts.set(item.status, (counts.get(item.status) ?? 0) + 1);
}
```

---

## When NOT to Use

```javascript
// Unnecessary: Small arrays (< 10 items)
const statuses = ['active', 'pending', 'done'];
if (statuses.includes(status)) { ... } // Fine for 3 items

// Unnecessary: Single lookup
const user = users.find(u => u.id === id); // Fine if done once

// Unnecessary: Already using index
const item = items[index]; // O(1) already
```

---

## toSorted() for Immutability

```javascript
// Bad: Mutates original array
const sorted = users.sort((a, b) => a.name.localeCompare(b.name));

// Good: Creates new sorted array
const sorted = users.toSorted((a, b) => a.name.localeCompare(b.name));

// Fallback for older environments
const sorted = [...users].sort((a, b) => a.name.localeCompare(b.name));
```

### Other Immutable Methods

```javascript
// toReversed() - immutable reverse
const reversed = items.toReversed();

// toSpliced() - immutable splice
const modified = items.toSpliced(2, 1, newItem);

// with() - immutable index assignment
const updated = items.with(0, newFirstItem);
```

---

## Performance Comparison

| Operation | Array | Set/Map |
|-----------|-------|---------|
| `includes()`/`has()` | O(n) | O(1) |
| `find()` by key | O(n) | O(1) with Map |
| `indexOf()` | O(n) | O(1) with Map |
| Add item | O(1) | O(1) |
| Delete item | O(n) | O(1) |

**Rule of thumb**: Use Set/Map when:
- Array has > 10 items AND
- Multiple lookups are performed
