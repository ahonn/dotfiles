# Server: Cache Patterns

**Priority**: HIGH
**Impact**: Server response time, Database load
**Applies to**: React Server Components, API routes, Data fetching

---

## React.cache() - Per-Request Deduplication

Deduplicate identical calls within a single request:

```javascript
import { cache } from 'react';

// Cached function - same args = same result within request
const getUser = cache(async (id: string) => {
  console.log('Fetching user:', id); // Only logs once per request
  return await db.user.findUnique({ where: { id } });
});

// Multiple components can call getUser(id) - only one DB query
async function UserProfile({ userId }) {
  const user = await getUser(userId);
  return <div>{user.name}</div>;
}

async function UserAvatar({ userId }) {
  const user = await getUser(userId); // Reuses cached result
  return <img src={user.avatar} />;
}
```

### Key Points

- Cache is **per-request** - cleared after request completes
- Only works in **React Server Components**
- Arguments are compared by reference for objects

---

## LRU Cache - Cross-Request Caching

For data that should persist across requests:

```javascript
import LRU from 'lru-cache';

const cache = new LRU<string, any>({
  max: 500,                    // Max items
  ttl: 1000 * 60 * 5,          // 5 minutes TTL
  updateAgeOnGet: true         // Reset TTL on access
});

async function getCachedData(key: string) {
  // Check cache first
  if (cache.has(key)) {
    return cache.get(key);
  }

  // Fetch and cache
  const data = await fetchData(key);
  cache.set(key, data);
  return data;
}
```

### With Stale-While-Revalidate

```javascript
const cache = new LRU<string, { data: any; timestamp: number }>({
  max: 500
});

const STALE_TIME = 1000 * 60;      // 1 minute
const MAX_AGE = 1000 * 60 * 10;    // 10 minutes

async function getWithSWR(key: string) {
  const cached = cache.get(key);
  const now = Date.now();

  if (cached) {
    const age = now - cached.timestamp;

    // Fresh - return immediately
    if (age < STALE_TIME) {
      return cached.data;
    }

    // Stale but valid - return and revalidate in background
    if (age < MAX_AGE) {
      fetchAndCache(key); // Fire and forget
      return cached.data;
    }
  }

  // Expired or missing - fetch synchronously
  return await fetchAndCache(key);
}

async function fetchAndCache(key: string) {
  const data = await fetchData(key);
  cache.set(key, { data, timestamp: Date.now() });
  return data;
}
```

---

## Next.js Caching

### unstable_cache (App Router)

```javascript
import { unstable_cache } from 'next/cache';

const getCachedUser = unstable_cache(
  async (id: string) => {
    return await db.user.findUnique({ where: { id } });
  },
  ['user'],           // Cache key prefix
  {
    revalidate: 60,   // Seconds
    tags: ['user']    // For on-demand revalidation
  }
);

// Revalidate on demand
import { revalidateTag } from 'next/cache';
revalidateTag('user');
```

### fetch() Caching

```javascript
// Cached by default
const res = await fetch('https://api.example.com/data');

// Force no cache
const res = await fetch('https://api.example.com/data', {
  cache: 'no-store'
});

// Revalidate every 60 seconds
const res = await fetch('https://api.example.com/data', {
  next: { revalidate: 60 }
});

// Tag for on-demand revalidation
const res = await fetch('https://api.example.com/data', {
  next: { tags: ['data'] }
});
```

---

## Minimize RSC Serialization

Only pass what the client needs:

```javascript
// Bad: Serializes entire user object (50 fields)
async function Page() {
  const user = await getUser();
  return <ClientProfile user={user} />;
}

// Good: Only serialize needed fields
async function Page() {
  const user = await getUser();
  return (
    <ClientProfile
      name={user.name}
      avatar={user.avatar}
      bio={user.bio}
    />
  );
}
```

### With Type Safety

```typescript
// Define exactly what client receives
interface ClientUserData {
  name: string;
  avatar: string;
  bio: string;
}

function pickClientData(user: FullUser): ClientUserData {
  return {
    name: user.name,
    avatar: user.avatar,
    bio: user.bio
  };
}

async function Page() {
  const user = await getUser();
  return <ClientProfile {...pickClientData(user)} />;
}
```

---

## Cache Invalidation Patterns

### Time-Based

```javascript
const cache = new LRU({ ttl: 1000 * 60 * 5 }); // 5 minutes
```

### Event-Based

```javascript
// On data mutation
async function updateUser(id: string, data: UserUpdate) {
  await db.user.update({ where: { id }, data });
  cache.delete(`user:${id}`);
}
```

### Tag-Based (Next.js)

```javascript
// Tag cache entries
const res = await fetch(url, { next: { tags: ['user', `user:${id}`] } });

// Invalidate by tag
revalidateTag('user');        // All user data
revalidateTag(`user:${id}`);  // Specific user
```

---

## Related Rules

- [async-waterfall-elimination.md](async-waterfall-elimination.md)
- [async-parallel-requests.md](async-parallel-requests.md)
