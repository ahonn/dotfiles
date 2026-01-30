# React Compiler

React Compiler automatically optimizes React apps at build time by adding memoization. It eliminates the need for manual `memo()`, `useMemo()`, and `useCallback()` in most cases.

## What It Does

```javascript
// Before: Manual memoization (error-prone)
const ExpensiveComponent = memo(function({ data, onClick }) {
  const processed = useMemo(() => expensiveProcess(data), [data]);
  const handleClick = useCallback((item) => onClick(item.id), [onClick]);

  return processedData.map(item => (
    <Item key={item.id} onClick={() => handleClick(item)} /> // 🔴 Breaks memo!
  ));
});

// After: React Compiler handles it
function ExpensiveComponent({ data, onClick }) {
  const processed = expensiveProcess(data);
  const handleClick = (item) => onClick(item.id);

  return processedData.map(item => (
    <Item key={item.id} onClick={() => handleClick(item)} /> // ✅ Optimized
  ));
}
```

**Key insight**: Compiler catches subtle bugs like arrow functions in JSX that break manual memoization.

## Should You Use It?

| Scenario | Recommendation |
|----------|----------------|
| New React 19 project | ✅ Enable by default |
| Existing codebase with strict mode | ✅ Good candidate |
| Heavy manual memoization | ✅ Big wins, remove boilerplate |
| Breaking Rules of React | ⚠️ Fix violations first |
| Library code | ⚠️ Test thoroughly |

## Installation

```bash
npm install -D babel-plugin-react-compiler
```

```javascript
// babel.config.js
module.exports = {
  plugins: [
    ['babel-plugin-react-compiler', {
      // options
    }],
  ],
};
```

## Incremental Adoption Strategies

### Strategy 1: Directory-based

```javascript
// babel.config.js
module.exports = {
  plugins: [
    ['babel-plugin-react-compiler', {
      sources: (filename) => {
        return filename.includes('src/components');
      },
    }],
  ],
};
```

### Strategy 2: Opt-in with directive

```javascript
// babel.config.js - enable annotation mode
module.exports = {
  plugins: [
    ['babel-plugin-react-compiler', {
      compilationMode: 'annotation',
    }],
  ],
};

// Component file - opt in
function MyComponent() {
  'use memo'; // Compiler processes this component
  return <div>...</div>;
}
```

### Strategy 3: Runtime gating

```javascript
// babel.config.js
module.exports = {
  plugins: [
    ['babel-plugin-react-compiler', {
      runtimeModule: 'react-compiler-runtime',
      gating: {
        source: 'MyFeatureFlags',
        importSpecifierName: 'isCompilerEnabled',
      },
    }],
  ],
};
```

## Impact on Memoization Strategy

### With Compiler

```javascript
// ✅ Just write simple code
function UserList({ users, onSelect }) {
  const sorted = users.toSorted((a, b) => a.name.localeCompare(b.name));

  return sorted.map(user => (
    <UserCard
      key={user.id}
      user={user}
      onSelect={() => onSelect(user.id)}
    />
  ));
}
```

### Without Compiler (current best practice)

```javascript
// Manual optimization still needed
const UserList = memo(function({ users, onSelect }) {
  const sorted = useMemo(
    () => users.toSorted((a, b) => a.name.localeCompare(b.name)),
    [users]
  );

  const handleSelect = useCallback(
    (id) => onSelect(id),
    [onSelect]
  );

  return sorted.map(user => (
    <UserCard
      key={user.id}
      user={user}
      onSelect={handleSelect}
      userId={user.id} // Pass id separately to avoid closure
    />
  ));
});
```

## What About Existing memo/useMemo/useCallback?

**Safe to keep**: Compiler skips already-memoized code. No need to remove.

**Can remove**: After compiler adoption, manual memoization becomes redundant. Remove for cleaner code.

**Recommendation**:
1. Enable compiler
2. Verify app works correctly
3. Gradually remove manual memoization in new code
4. Optionally clean up old code

## Rules of React (Compiler Prerequisites)

Compiler requires code to follow Rules of React:

| Rule | Example Violation |
|------|-------------------|
| Components must be pure | Mutating props/state during render |
| Props/state are immutable | `props.items.push(newItem)` |
| Return values are immutable | Returning then mutating JSX |
| No side effects in render | Calling APIs during render |

### Checking Compliance

```bash
npx react-compiler-healthcheck
```

Or use ESLint plugin:

```bash
npm install -D eslint-plugin-react-compiler
```

```javascript
// eslint.config.js
import reactCompiler from 'eslint-plugin-react-compiler';

export default [
  {
    plugins: { 'react-compiler': reactCompiler },
    rules: {
      'react-compiler/react-compiler': 'error',
    },
  },
];
```

## Debugging

### Opting out specific components

```javascript
function ProblematicComponent() {
  'use no memo'; // Skip compilation for this component
  // ... code that breaks with compiler
}
```

### Common issues

| Symptom | Likely Cause |
|---------|--------------|
| Infinite loop | Mutating state/props in render |
| Stale data | Breaking immutability rules |
| Missing updates | Side effects in render phase |

## Quick Reference

| Before Compiler | After Compiler |
|-----------------|----------------|
| `memo(Component)` | Just `Component` |
| `useMemo(() => compute(), [deps])` | Just `compute()` |
| `useCallback(fn, [deps])` | Just `fn` |
| Careful with inline functions | Write naturally |
