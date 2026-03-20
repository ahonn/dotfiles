---
name: no-useeffect
description: >
  Enforce a strict ban on direct useEffect calls in React code. Replace with derived state,
  event handlers, data-fetching libraries, useMountEffect, or key-based remounting.
  Use when: (1) Writing new React components, (2) Reviewing React code for effect usage,
  (3) Refactoring existing useEffect calls, (4) AI agent is about to add useEffect.
  Triggers on: useEffect, effect hook, side effect, sync state, dependency array,
  infinite loop, race condition, effect cleanup.
---

# No Direct useEffect

**Rule: Never call `useEffect` directly.** All 5 replacement patterns below cover every legitimate use case.

## useMountEffect — The Only Allowed Effect Wrapper

```typescript
export function useMountEffect(effect: () => void | (() => void)) {
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(effect, []);
}
```

Use `useMountEffect` only for one-time external system sync (DOM, third-party widgets, browser APIs). For anything else, use Rules 1-3 or 5.

## Rule 1: Derive State, Don't Sync It

Smell: `useEffect(() => setX(deriveFromY(y)), [y])` or state that mirrors other state/props.

```typescript
// BAD: two render cycles
const [filtered, setFiltered] = useState([]);
useEffect(() => {
  setFiltered(products.filter((p) => p.inStock));
}, [products]);

// GOOD: compute inline
const filtered = products.filter((p) => p.inStock);
```

```typescript
// BAD: effect chain creates loop risk
useEffect(() => { setTax(subtotal * 0.1); }, [subtotal]);
useEffect(() => { setTotal(subtotal + tax); }, [subtotal, tax]);

// GOOD: plain derivation
const tax = subtotal * 0.1;
const total = subtotal + tax;
```

## Rule 2: Use Data-Fetching Libraries

Smell: `useEffect` with `fetch()` + `setState()`, or re-implementing caching/cancellation/retries.

```typescript
// BAD: race condition when productId changes fast
useEffect(() => {
  fetchProduct(productId).then(setProduct);
}, [productId]);

// GOOD: library handles cancellation, caching, staleness
const { data: product } = useQuery(
  ['product', productId],
  () => fetchProduct(productId)
);
```

Acceptable libraries: TanStack Query, SWR, Apollo, RTK Query, tRPC, Relay, or framework loaders (Next.js/Remix/Expo Router).

## Rule 3: Event Handlers, Not Effects

Smell: state used as a flag so an effect can do the real work ("set flag → effect runs → reset flag").

```typescript
// BAD: effect as action relay
const [liked, setLiked] = useState(false);
useEffect(() => {
  if (liked) { postLike(); setLiked(false); }
}, [liked]);

// GOOD: direct handler
<button onClick={() => postLike()}>Like</button>
```

If a user action triggers the work, do it in the handler.

## Rule 4: useMountEffect for One-Time External Sync

Valid uses: DOM focus/scroll, third-party widget init, browser API subscriptions.

```typescript
// BAD: guard inside effect
useEffect(() => {
  if (!isLoading) playVideo();
}, [isLoading]);

// GOOD: conditional mounting — mount only when preconditions met
function VideoPlayerWrapper({ isLoading }) {
  if (isLoading) return <LoadingScreen />;
  return <VideoPlayer />;
}

function VideoPlayer() {
  useMountEffect(() => playVideo());
}
```

Parent owns orchestration; child assumes preconditions are met.

## Rule 5: Reset with key, Not Dependency Choreography

Smell: effect whose only job is to reset local state when an ID/prop changes.

```typescript
// BAD: manual reset on ID change
useEffect(() => { loadVideo(videoId); }, [videoId]);

// GOOD: key forces clean remount
<VideoPlayer key={videoId} videoId={videoId} />

function VideoPlayer({ videoId }) {
  useMountEffect(() => loadVideo(videoId));
}
```

If the requirement is "start fresh when X changes", use React's remount semantics via `key`.

## Quick Decision Tree

```
Need to compute a value from state/props?
  → Rule 1: Derive inline

Need to fetch data?
  → Rule 2: Use a query library

Responding to a user action?
  → Rule 3: Event handler

One-time setup on mount (DOM, external system)?
  → Rule 4: useMountEffect

Need to reset when an ID/entity changes?
  → Rule 5: key prop on parent

None of the above?
  → Rethink. The answer is almost never useEffect.
```

## Why This Rule Exists

- **Brittleness**: dependency arrays hide coupling; unrelated refactors break effects silently
- **Infinite loops**: `state update → render → effect → state update` chains
- **Race conditions**: effect-based fetching without cancellation
- **Debugging pain**: "why did this run?" has no clear entrypoint like a handler does
- `useMountEffect` failures are binary and loud; `useEffect` failures degrade gradually and show up as flaky behavior
