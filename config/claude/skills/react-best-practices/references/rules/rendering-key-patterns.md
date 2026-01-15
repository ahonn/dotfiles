# Rendering: Key Patterns

**Priority**: MEDIUM
**Impact**: List rendering, Component identity, State preservation
**Applies to**: Lists, Dynamic components, Conditional rendering

---

## Core Rules

### 1. Use Stable Unique IDs

```javascript
// Good: Database ID
{users.map(user => (
  <UserCard key={user.id} user={user} />
))}

// Good: Composite key when no single ID
{items.map(item => (
  <Item key={`${item.category}-${item.name}`} item={item} />
))}
```

### 2. Never Use Array Index (Usually)

```javascript
// Bad: Index as key
{items.map((item, index) => (
  <Item key={index} item={item} />
))}
```

**Why it's bad:**
- Reordering breaks component identity
- State gets associated with wrong items
- Deletions cause state to "shift"

### 3. Never Use Random Values

```javascript
// Bad: Creates new key every render
{items.map(item => (
  <Item key={Math.random()} item={item} />
  <Item key={crypto.randomUUID()} item={item} />
))}
```

**Why it's bad:**
- Components remount every render
- All state is lost
- Terrible performance

---

## When Index IS Acceptable

Index as key is OK when ALL of these are true:

1. List is **static** (never reordered, filtered, or sorted)
2. Items have **no stable ID**
3. List is **never modified** (no additions/deletions)

```javascript
// OK: Static navigation items
const navItems = ['Home', 'About', 'Contact'];
{navItems.map((label, index) => (
  <NavLink key={index}>{label}</NavLink>
))}

// OK: Static table headers
const columns = ['Name', 'Email', 'Role'];
{columns.map((col, index) => (
  <th key={index}>{col}</th>
))}
```

---

## Key Placement

### Key Goes on Outermost Element in the Loop

```javascript
// Good: Key on the mapped element
{posts.map(post => (
  <article key={post.id}>
    <h2>{post.title}</h2>
    <p>{post.content}</p>
  </article>
))}

// Good: Key on component
{posts.map(post => (
  <PostCard key={post.id} post={post} />
))}
```

### Not on Inner Elements

```javascript
// Bad: Key inside the component
function PostCard({ post }) {
  return (
    <article key={post.id}> {/* Wrong place! */}
      {post.title}
    </article>
  );
}

// Bad: Key on wrapper when mapping
{posts.map(post => (
  <div> {/* Missing key! */}
    <PostCard key={post.id} post={post} /> {/* Wrong place! */}
  </div>
))}

// Good: Key on outermost in map
{posts.map(post => (
  <div key={post.id}>
    <PostCard post={post} />
  </div>
))}
```

---

## Key for Resetting State

Use key to force component remount and reset state:

```javascript
// Problem: State persists when switching users
function App() {
  const [userId, setUserId] = useState('1');
  return <UserProfile userId={userId} />; // State persists!
}

// Solution: Key forces remount
function App() {
  const [userId, setUserId] = useState('1');
  return <UserProfile key={userId} userId={userId} />; // Fresh state!
}
```

### Common Use Cases

```javascript
// Reset form when editing different item
<EditForm key={itemId} item={item} />

// Reset animation when content changes
<AnimatedCard key={cardId} content={content} />

// Reset scroll position
<ScrollContainer key={pageId}>
  <PageContent />
</ScrollContainer>
```

---

## Fragments and Keys

```javascript
// When using Fragment, use long form for key
{items.map(item => (
  <Fragment key={item.id}>
    <dt>{item.term}</dt>
    <dd>{item.description}</dd>
  </Fragment>
))}

// Short form <></> doesn't support key
{items.map(item => (
  <>  {/* Can't add key here! */}
    <dt>{item.term}</dt>
    <dd>{item.description}</dd>
  </>
))}
```

---

## Key Does Not Get Passed as Prop

```javascript
// key is NOT accessible inside component
function Item({ key, name }) { // key is undefined!
  console.log(key); // undefined
}

// Pass ID separately if needed
{items.map(item => (
  <Item key={item.id} id={item.id} name={item.name} />
))}

function Item({ id, name }) {
  console.log(id); // Works!
}
```

---

## Debugging Key Issues

### Symptoms of Wrong Keys

- Input loses focus when typing
- Checkbox state appears on wrong item after sort
- Animations replay unexpectedly
- Form fields show wrong values after reorder

### Detection

```javascript
// Add logging to see re-renders
function Item({ item }) {
  useEffect(() => {
    console.log('Item mounted:', item.id);
    return () => console.log('Item unmounted:', item.id);
  }, []);
  // ...
}
```

---

## Conditional Rendering Pitfall

Avoid `&&` with numbers - it renders `0`:

```javascript
// Bad: renders "0" when count is 0
{count && <Badge count={count} />}

// Good: explicit check
{count > 0 && <Badge count={count} />}
// or
{count > 0 ? <Badge count={count} /> : null}
```

Same applies to `array.length && <List />`.

---

## Summary Table

| Scenario | Key Strategy |
|----------|--------------|
| Database records | `key={record.id}` |
| Combined fields | `key={\`${a}-${b}\`}` |
| Static list | `key={index}` (acceptable) |
| Need fresh state | Change key to remount |
| Fragment with siblings | `<Fragment key={id}>` |
