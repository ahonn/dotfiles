# React Compiler

React Compiler can add memoization at build time when configured for compatible code. Confirm the installed React version, compiler version, framework integration, and compilation coverage before relying on it. Adoption is a separate build-tooling decision, not an automatic consequence of using a particular React version.

The configuration examples below are illustrative. Check current official React and framework documentation for the installed toolchain before applying them.

## What It Does

```javascript
// Manual memoization example
const ExpensiveComponent = memo(function({ data, onClick }) {
  const processed = useMemo(() => expensiveProcess(data), [data]);
  const handleClick = useCallback((item) => onClick(item.id), [onClick]);

  return processed.map(item => (
    <Item key={item.id} onClick={() => handleClick(item)} />
  ));
});

// After: React Compiler handles it
function ExpensiveComponent({ data, onClick }) {
  const processed = expensiveProcess(data);
  const handleClick = (item) => onClick(item.id);

  return processed.map(item => (
    <Item key={item.id} onClick={() => handleClick(item)} />
  ));
}
```

An inline callback is not a correctness bug. It matters to performance when changing function identity prevents a useful optimization; verify that relationship before changing it.

## Should You Use It?

| Scenario | Recommendation |
|----------|----------------|
| Adoption is requested or addresses an identified need | Check supported integration and evaluate a focused rollout |
| Compiler is already configured | Confirm the affected code is compiled before relying on its optimizations |
| Heavy manual memoization | Preserve it during adoption; evaluate any cleanup separately |
| Breaking Rules of React | Fix relevant violations before relying on compilation |
| Library code | Check the supported consumer and build configurations |

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

### Without Compiler, When Profiling Justifies Memoization

```javascript
// Use this pattern only for a demonstrated rendering cost
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

Keep existing memoization during adoption. Do not assume all compiled code is optimized or that each manual memo is redundant.

Remove an existing memo only when the affected code is covered by compilation, its identity behavior is understood, and relevant behavior and performance checks support the change. Avoid repository-wide memo cleanup as a side effect of unrelated work.

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

## Verification

Check compilation diagnostics for the affected code, exercise the relevant behavior, and compare the identified performance problem before and after adoption. Preserve a focused scope when compilation is skipped or results are inconclusive.
