---
name: react-best-practices
description: "React best practices from react.dev and Vercel. Use when: reviewing code, debugging performance. Triggers on: React performance, re-render, bundle size."
user-invocable: false
---

# React Best Practices

Performance patterns and guidelines from react.dev and Vercel Engineering.

## Quick Reference (Priority Order)

### CRITICAL - Must Follow

| Rule | Impact | Reference |
|------|--------|-----------|
| Eliminate waterfalls | First paint, TTI | [async-waterfall-elimination.md](references/rules/async-waterfall-elimination.md) |
| Parallel data fetching | Load time | [async-parallel-requests.md](references/rules/async-parallel-requests.md) |
| Avoid barrel imports | Bundle size | [bundle-barrel-imports.md](references/rules/bundle-barrel-imports.md) |

### HIGH - Strongly Recommended

| Rule | Impact | Reference |
|------|--------|-----------|
| Dynamic imports | Code splitting | [bundle-dynamic-import.md](references/rules/bundle-dynamic-import.md) |
| Preload on user intent | Perceived latency | [bundle-preload.md](references/rules/bundle-preload.md) |
| Strategic memo() | Render perf | [rerender-memo-strategy.md](references/rules/rerender-memo-strategy.md) |
| Server caching | Server response | [server-cache-patterns.md](references/rules/server-cache-patterns.md) |

### MEDIUM - Recommended

| Rule | Impact | Reference |
|------|--------|-----------|
| Context splitting | Avoid rerenders | [rerender-context-splitting.md](references/rules/rerender-context-splitting.md) |
| startTransition | UI responsiveness | [rerender-transitions.md](references/rules/rerender-transitions.md) |
| Set/Map lookups | O(1) vs O(n) | [js-set-map-lookups.md](references/rules/js-set-map-lookups.md) |
| Key patterns | List rendering | [rendering-key-patterns.md](references/rules/rendering-key-patterns.md) |

### LOW - Nice to Have

| Rule | Impact | Reference |
|------|--------|-----------|
| content-visibility | Long list render | [rendering-content-visibility.md](references/rules/rendering-content-visibility.md) |
| Hydration flicker | SSR stability | [rendering-hydration-flicker.md](references/rules/rendering-hydration-flicker.md) |
| Hoist static JSX | Avoid re-creation | [rendering-hoist-static-jsx.md](references/rules/rendering-hoist-static-jsx.md) |

---

## Quick Decision Tree

```
Performance Issue?
├── Slow initial load?
│   ├── Check for waterfalls → async-waterfall-elimination.md
│   ├── Check bundle size → bundle-barrel-imports.md
│   └── Preload on intent → bundle-preload.md
├── Slow interactions?
│   ├── Check re-renders → rerender-memo-strategy.md
│   ├── Check Context usage → rerender-context-splitting.md
│   └── Use transitions → rerender-transitions.md
├── Long list jank?
│   └── Use content-visibility → rendering-content-visibility.md
├── SSR flicker?
│   └── Inline script pattern → rendering-hydration-flicker.md
└── Slow server?
    └── Check caching → server-cache-patterns.md
```

---

## Reference Files

| File | Content |
|------|---------|
| [HOOKS-GUIDE.md](HOOKS-GUIDE.md) | Hook patterns, decision guides, pitfalls |
| [references/rules/](references/rules/) | Individual rule files (14 total) |

**Search rules**: `grep -l "keyword" references/rules/`
