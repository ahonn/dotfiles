# Async: Waterfall Elimination

**Priority**: CRITICAL
**Impact**: First contentful paint, Time to interactive
**Applies to**: Data fetching, API calls, async operations

---

## The Problem

Sequential `await` statements create waterfall patterns where each request waits for the previous one to complete:

```javascript
// Waterfall pattern - 650ms total
async function UserDashboard() {
  const user = await fetchUser();              // Request 1: 200ms
  const profile = await fetchProfile(user.id); // Request 2: 150ms (waits for 1)
  const posts = await fetchPosts(user.id);     // Request 3: 300ms (waits for 2)
  // Total: 200 + 150 + 300 = 650ms
}
```

**Visual timeline:**
```
fetchUser    |████████|
fetchProfile          |██████|
fetchPosts                   |████████████|
             0       200    350          650ms
```

---

## Solutions

### Pattern 1: Promise.all for Independent Requests

When requests don't depend on each other:

```javascript
// Parallel - ~300ms total (longest request)
async function Dashboard() {
  const [user, settings, notifications] = await Promise.all([
    fetchUser(),
    fetchGlobalSettings(),
    fetchNotifications()
  ]);
  // Total: max(200, 100, 300) = 300ms
}
```

**Visual timeline:**
```
fetchUser         |████████|
fetchSettings     |████|
fetchNotifications|████████████|
                  0            300ms
```

### Pattern 2: Hybrid - Parallel Then Sequential

When some requests depend on others:

```javascript
async function Dashboard() {
  // First: independent requests in parallel
  const [user, globalSettings] = await Promise.all([
    fetchUser(),
    fetchGlobalSettings()
  ]);

  // Then: dependent requests in parallel
  const [profile, posts] = await Promise.all([
    fetchProfile(user.id),
    fetchPosts(user.id)
  ]);
}
```

### Pattern 3: Defer Await Until Needed

Start promises early, await only when data is needed:

```javascript
async function Page() {
  // Start all fetches immediately (no await)
  const userPromise = fetchUser();
  const postsPromise = fetchPosts();
  const commentsPromise = fetchComments();

  // Render something that doesn't need data
  renderHeader();

  // Await only when data is actually needed
  const user = await userPromise;
  renderUserSection(user);

  const posts = await postsPromise;
  renderPosts(posts);
}
```

### Pattern 4: Suspense Boundaries (React)

Let React handle parallel loading:

```javascript
function Dashboard() {
  return (
    <div>
      <Suspense fallback={<HeaderSkeleton />}>
        <Header /> {/* Fetches independently */}
      </Suspense>

      <Suspense fallback={<SidebarSkeleton />}>
        <Sidebar /> {/* Fetches independently */}
      </Suspense>

      <Suspense fallback={<ContentSkeleton />}>
        <Content /> {/* Fetches independently */}
      </Suspense>
    </div>
  );
}

// Each component fetches its own data
async function Header() {
  const data = await fetchHeaderData();
  return <header>{data.title}</header>;
}
```

### Pattern 5: Component Composition (RSC)

Split async components to enable parallel fetching:

```javascript
// Bad: sequential in single component
async function Page() {
  const header = await fetchHeader();  // Blocks
  const sidebar = await fetchSidebar(); // Waits
  return (
    <div>
      <Header data={header} />
      <Sidebar data={sidebar} />
    </div>
  );
}

// Good: parallel via component composition
export default function Page() {
  return (
    <div>
      <Header />   {/* Fetches in parallel */}
      <Sidebar />  {/* Fetches in parallel */}
    </div>
  );
}

async function Header() {
  const data = await fetchHeader();
  return <header>{data}</header>;
}

async function Sidebar() {
  const data = await fetchSidebar();
  return <aside>{data}</aside>;
}
```

---

## Detection Patterns

Look for these code smells:

```javascript
// Multiple sequential awaits
const a = await fetchA();
const b = await fetchB();
const c = await fetchC();

// Awaiting in a loop
for (const id of ids) {
  const data = await fetchData(id); // N sequential requests!
}

// Conditional await that could be parallelized
const user = await fetchUser();
if (user.isPremium) {
  const premium = await fetchPremiumData(); // Could start earlier
}
```

---

## Related Rules

- [async-parallel-requests.md](async-parallel-requests.md) - More parallel patterns
- [server-cache-patterns.md](server-cache-patterns.md) - Reduce unnecessary fetches
