# Bundle: Avoid Barrel Imports

**Priority**: CRITICAL
**Impact**: Bundle size, Initial load time
**Applies to**: Module imports, Component libraries

---

## The Problem

Barrel files (index.js that re-exports) can pull in entire libraries:

```javascript
// components/index.js (barrel file)
export { Button } from './Button';
export { Modal } from './Modal';
export { Chart } from './Chart';      // Heavy component
export { DataGrid } from './DataGrid'; // Heavy component
```

```javascript
// Your code
import { Button } from '@/components';
// Imports ALL exports from the barrel, including Chart and DataGrid!
```

---

## Solution

Import directly from the source file:

```javascript
// Bad: barrel import
import { Button } from '@/components';

// Good: direct import
import Button from '@/components/Button';
import { Button } from '@/components/Button';
```

---

## Common Offenders

### UI Libraries

```javascript
// Bad
import { Button, Input } from '@mui/material';
import { DatePicker } from 'antd';

// Good
import Button from '@mui/material/Button';
import Input from '@mui/material/Input';
import DatePicker from 'antd/es/date-picker';
```

### Icon Libraries

```javascript
// Bad: imports ALL icons
import { HomeIcon } from '@heroicons/react/24/outline';

// Good: direct import
import HomeIcon from '@heroicons/react/24/outline/HomeIcon';
```

### Utility Libraries

```javascript
// Bad: imports entire lodash
import { debounce } from 'lodash';

// Good: direct import
import debounce from 'lodash/debounce';

// Better: use lodash-es with tree shaking
import { debounce } from 'lodash-es';
```

---

## Project Structure

### Avoid Creating Barrels

```javascript
// Don't create: components/index.js
export * from './Button';
export * from './Modal';
export * from './Chart';
```

### If You Must Have Barrels

Use explicit named exports and ensure bundler tree-shaking works:

```javascript
// components/index.js
export { Button } from './Button';
export { Modal } from './Modal';
// Don't use: export * from './SomeModule';
```

And configure your bundler:

```javascript
// next.config.js
module.exports = {
  modularizeImports: {
    '@/components': {
      transform: '@/components/{{member}}'
    }
  }
};
```

---

## Detection

### Check Bundle Size

```bash
# Next.js
npx @next/bundle-analyzer

# Webpack
npx webpack-bundle-analyzer stats.json
```

### Look for Warning Signs

- Bundle contains unused components
- Importing from library root (e.g., `from 'library'` vs `from 'library/specific'`)
- index.js files with many exports
- `export * from` statements

---

## Framework-Specific

### Next.js

```javascript
// next.config.js
module.exports = {
  modularizeImports: {
    'lodash': {
      transform: 'lodash/{{member}}'
    },
    '@mui/material': {
      transform: '@mui/material/{{member}}'
    },
    '@mui/icons-material': {
      transform: '@mui/icons-material/{{member}}'
    }
  }
};
```

### Vite

Tree-shaking should work by default, but verify with:

```javascript
// vite.config.js
export default {
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          // Analyze chunks
        }
      }
    }
  }
};
```

---

## Related Rules

- [bundle-dynamic-import.md](bundle-dynamic-import.md)
