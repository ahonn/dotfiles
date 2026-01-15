# Async: Parallel Requests

**Priority**: CRITICAL
**Impact**: Load time, First contentful paint
**Applies to**: Data fetching, API calls

---

## Core Pattern

Use `Promise.all()` for independent async operations:

```javascript
// Sequential: 500ms total
const user = await fetchUser();     // 200ms
const posts = await fetchPosts();   // 300ms

// Parallel: 300ms total
const [user, posts] = await Promise.all([
  fetchUser(),    // 200ms
  fetchPosts()    // 300ms (runs simultaneously)
]);
```

---

## Patterns

### Pattern 1: All Independent

```javascript
async function loadDashboard() {
  const [user, notifications, settings] = await Promise.all([
    fetchUser(),
    fetchNotifications(),
    fetchSettings()
  ]);
  return { user, notifications, settings };
}
```

### Pattern 2: Start Early, Await Late

```javascript
async function processPage() {
  // Start all promises immediately
  const dataPromise = fetchData();
  const configPromise = fetchConfig();

  // Do synchronous work
  validateInput();
  setupLogging();

  // Await when needed
  const data = await dataPromise;
  const config = await configPromise;
}
```

### Pattern 3: Partial Dependencies

When some requests depend on others:

```javascript
async function loadUserDashboard(userId) {
  // Layer 1: Independent requests
  const [user, globalConfig] = await Promise.all([
    fetchUser(userId),
    fetchGlobalConfig()
  ]);

  // Layer 2: Requests that depend on user
  const [profile, posts, followers] = await Promise.all([
    fetchProfile(user.id),
    fetchPosts(user.id),
    fetchFollowers(user.id)
  ]);

  return { user, globalConfig, profile, posts, followers };
}
```

### Pattern 4: Promise.allSettled for Error Tolerance

```javascript
async function loadWithFallbacks() {
  const results = await Promise.allSettled([
    fetchPrimaryData(),
    fetchSecondaryData(),
    fetchOptionalData()
  ]);

  return results.map((result, i) =>
    result.status === 'fulfilled' ? result.value : defaultValues[i]
  );
}
```

### Pattern 5: Batching Loop Requests

```javascript
// Bad: Sequential loop - N * latency
for (const id of ids) {
  const data = await fetchData(id);
  results.push(data);
}

// Good: Parallel - 1 * latency
const results = await Promise.all(
  ids.map(id => fetchData(id))
);

// Better: Chunked parallel (avoid overwhelming server)
async function fetchInChunks(ids, chunkSize = 10) {
  const results = [];
  for (let i = 0; i < ids.length; i += chunkSize) {
    const chunk = ids.slice(i, i + chunkSize);
    const chunkResults = await Promise.all(
      chunk.map(id => fetchData(id))
    );
    results.push(...chunkResults);
  }
  return results;
}
```

---

## Anti-patterns

```javascript
// Anti-pattern 1: Unnecessary await in map
const results = await Promise.all(
  items.map(async (item) => {
    const data = await fetchData(item.id); // Fine
    return await processData(data);        // Unnecessary await
  })
);

// Anti-pattern 2: Sequential in disguise
let results = [];
for (const item of items) {
  results.push(await fetchData(item.id)); // Still sequential!
}

// Anti-pattern 3: Creating promises but not awaiting them
const promises = items.map(item => fetchData(item.id));
// Missing: await Promise.all(promises)
```

---

## Related Rules

- [async-waterfall-elimination.md](async-waterfall-elimination.md)
- [server-cache-patterns.md](server-cache-patterns.md)
