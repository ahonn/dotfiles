# Bundle: Dynamic Imports

**Priority**: HIGH
**Impact**: Initial bundle size, Code splitting
**Applies to**: Heavy components, Route-level splitting

---

## Core Patterns

### React.lazy for Components

```javascript
import { lazy, Suspense } from 'react';

// Lazy load heavy component
const Chart = lazy(() => import('./Chart'));
const DataGrid = lazy(() => import('./DataGrid'));

function Dashboard() {
  return (
    <Suspense fallback={<Loading />}>
      <Chart data={data} />
    </Suspense>
  );
}
```

### Next.js dynamic()

```javascript
import dynamic from 'next/dynamic';

// Basic dynamic import
const Chart = dynamic(() => import('./Chart'));

// With loading state
const Chart = dynamic(() => import('./Chart'), {
  loading: () => <ChartSkeleton />
});

// Disable SSR for client-only components
const MapComponent = dynamic(() => import('./Map'), {
  ssr: false
});

// Named export
const Modal = dynamic(() =>
  import('./Modal').then(mod => mod.Modal)
);
```

---

## When to Use

### Good Candidates

- **Heavy visualization components**: Charts, maps, rich text editors
- **Below-the-fold content**: Components not visible on initial load
- **Conditional features**: Admin panels, premium features
- **Large libraries**: PDF viewers, code editors

```javascript
// Chart library (~500KB)
const Chart = dynamic(() => import('recharts').then(m => m.LineChart));

// Rich text editor (~200KB)
const Editor = dynamic(() => import('@tiptap/react'), { ssr: false });

// Map component (~150KB)
const Map = dynamic(() => import('react-map-gl'), { ssr: false });
```

### Bad Candidates

- Small, frequently used components
- Above-the-fold content
- Components needed for SEO

---

## Preloading

### Preload on User Intent

```javascript
import dynamic from 'next/dynamic';

const Modal = dynamic(() => import('./Modal'));

function Button() {
  // Preload when user hovers
  const handleMouseEnter = () => {
    import('./Modal'); // Triggers preload
  };

  return (
    <button onMouseEnter={handleMouseEnter} onClick={openModal}>
      Open Modal
    </button>
  );
}
```

### Preload on Route Hover

```javascript
import Link from 'next/link';

function NavLink({ href, children }) {
  return (
    <Link
      href={href}
      onMouseEnter={() => {
        // Next.js automatically prefetches, but you can add more
        import(`../pages${href}`);
      }}
    >
      {children}
    </Link>
  );
}
```

---

## Route-Level Splitting

### Next.js App Router

Routes are automatically code-split:

```
app/
  dashboard/
    page.tsx     # Separate chunk
  settings/
    page.tsx     # Separate chunk
```

### React Router

```javascript
import { lazy } from 'react';
import { Routes, Route } from 'react-router-dom';

const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));

function App() {
  return (
    <Suspense fallback={<PageLoading />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/settings" element={<Settings />} />
      </Routes>
    </Suspense>
  );
}
```

---

## Named Exports

```javascript
// Component file with named export
// components/Modal.tsx
export function Modal() { ... }
export function ModalHeader() { ... }

// Dynamic import with named export
const Modal = dynamic(() =>
  import('./Modal').then(mod => mod.Modal)
);

// Or using destructuring
const Modal = dynamic(async () => {
  const { Modal } = await import('./Modal');
  return Modal;
});
```

---

## Error Handling

```javascript
import { lazy, Suspense } from 'react';
import { ErrorBoundary } from 'react-error-boundary';

const Chart = lazy(() => import('./Chart'));

function Dashboard() {
  return (
    <ErrorBoundary fallback={<ChartError />}>
      <Suspense fallback={<ChartLoading />}>
        <Chart />
      </Suspense>
    </ErrorBoundary>
  );
}
```

---

## Related Rules

- [bundle-barrel-imports.md](bundle-barrel-imports.md)
