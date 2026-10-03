---
name: react-best-practices
description: Diagnose React performance problems or review and improve state and effect design.
user-invocable: false
---

# React Performance and State Design

Start from the reported behavior and relevant implementation. Select only the references that address the task; the catalog is not a checklist to apply to every component.

## Establish applicability

- Inspect the installed React version, framework, target platform, build configuration, and existing compiler setup before proposing version-dependent changes.
- Identify the bottleneck with a reproduction, profiler trace, bundle report, or concrete dependency path. If measurement is unavailable, label the diagnosis as a hypothesis and explain how to validate it.
- Prefer a focused change with an observable benefit. Do not add or remove memoization, introduce caching, change build tooling, or preload resources without a reason tied to the task.
- Follow the project's state, effect, and data-fetching conventions. Web rendering, SSR, and framework-specific examples do not automatically apply to React Native or a different framework.

## Read by problem

| Problem or decision | Relevant references |
|---------------------|---------------------|
| Redundant state or synchronization bugs | [State structure](references/state-structure.md), [immutable updates](references/immutable-updates.md), [effect pitfalls](references/effect-pitfalls.md) |
| A specific hook lifecycle or API question | [Hooks guide](references/hooks-guide.md) |
| Requests wait on independent work | [Waterfall elimination](references/async-waterfall-elimination.md), [parallel requests](references/async-parallel-requests.md) |
| Bundle report shows costly imports or initial code | [Barrel imports](references/bundle-barrel-imports.md), [dynamic imports](references/bundle-dynamic-import.md) |
| Resource loading delays a likely user action | [Preload on intent](references/bundle-preload.md) |
| Profiler shows costly repeated rendering | [Memoization strategy](references/rerender-memo-strategy.md), [context splitting](references/rerender-context-splitting.md) |
| Non-urgent rendering blocks an interaction | [Transitions](references/rerender-transitions.md) |
| Compiler adoption or compilation behavior is in scope | [React Compiler](references/react-compiler.md) |
| Repeated lookup cost is significant | [Set and Map lookups](references/js-set-map-lookups.md) |
| List identity or unexpected remounts | [Key patterns](references/rendering-key-patterns.md) |
| Expensive off-screen web content | [Content visibility](references/rendering-content-visibility.md) |
| Server-rendered web content visibly changes on hydration | [Hydration flicker](references/rendering-hydration-flicker.md) |
| Repeated static JSX creation is relevant to a measured cost | [Hoist static JSX](references/rendering-hoist-static-jsx.md) |
| Repeated server work or cache correctness | [Server caching](references/server-cache-patterns.md) |

Reference priority labels and examples describe possible interventions, not mandatory changes. Verify version-sensitive APIs and configuration against the installed toolchain and current official documentation before using them. React version alone is not a reason to enable React Compiler.

## Complete the change

Preserve required behavior and use the applicable AGENTS.md test mode. For performance changes, compare the affected interaction or load path before and after when feasible; otherwise state the remaining verification gap. Report the concrete benefit and relevant limitations without claiming an unmeasured speedup.
