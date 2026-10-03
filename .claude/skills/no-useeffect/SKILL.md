---
name: no-useeffect
description: Apply the user's ban on direct React useEffect calls when implementing or refactoring component synchronization.
---

# No Direct useEffect

Do not call `useEffect` directly in application components or feature hooks. Use the project's approved primitives and lifecycle architecture. This is the user's coding preference; it does not imply React has no legitimate effect use cases.

Inspect project guidance and lint exemptions first. A project may permit direct effects inside designated low-level primitives such as `useMountEffect`, `useSharedValueSync`, or `useDelayedFlag`. Respect those explicit boundaries instead of imposing a single global wrapper. Do not introduce an unapproved wrapper simply to evade the ban.

## Choose by the behavior needed

| Need | Preferred approach |
|------|--------------------|
| Compute a value from props or state | Derive during render; memoize only when the computation warrants it |
| Respond to a user action | Run the action in its event handler or store action |
| Fetch and cache server data | Use the project's query library or framework loader |
| Read a mutable external store | Use its supported hook or `useSyncExternalStore` |
| Initialize an external resource for a mount | Use the approved mount primitive with cleanup |
| Synchronize a changing input with an external resource | Use an approved reactive primitive or the resource's lifecycle API |
| Reset all local state for a new entity | Use `key` when a full remount matches the intended behavior |

These are decision aids, not an exhaustive replacement theorem. When none fits, inspect the external system's lifecycle and existing primitives before proposing a design. Follow global AGENTS.md authorization rules; this skill adds no confirmation requirement for established project patterns.

## Preserve semantics during refactoring

- Derived state should have a single source of truth. Avoid storing values that can be computed from current inputs.
- User-triggered work belongs in the action path; do not relay it through a state flag and an effect.
- Use query keys and options consistent with the installed data library. Cancellation requires the query function or transport to honor the relevant signal; a library alone does not make every request cancellable.
- A mount primitive is appropriate only when setup belongs to that mounted instance. It is not a drop-in replacement for synchronization that must react to changing dependencies.
- Mount setup may run again after remounts and during development lifecycle checks. Return cleanup, release subscriptions and resources, and handle async completion after disposal.
- A `key` resets the entire subtree, including focus, playback, animations, and local state. Use it only when those resets are intended; do not remount solely to avoid reasoning about updates.
- Do not replace `useEffect` with `useLayoutEffect` merely to bypass the rule. Use the project's approved layout mechanism only when synchronous layout work is actually required.

For a new low-level primitive, keep its contract explicit about updates, cleanup, and ownership, and follow project rules for effect exemptions. Select validation through global AGENTS.md; do not add tests solely because an effect was removed.
