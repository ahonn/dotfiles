# Rendering: Prevent Hydration Flicker

**Priority**: MEDIUM
**Impact**: Visual stability, User experience
**Applies to**: SSR, Theme switching, localStorage-dependent UI

---

## The Problem

Content depending on client-side storage (localStorage, cookies) causes either:
1. SSR errors (accessing `localStorage` on server)
2. Visual flicker (showing default then switching)

---

## Common Mistakes

### Mistake 1: Direct localStorage Access

```javascript
// Bad: Breaks SSR - localStorage undefined on server
function ThemeWrapper({ children }) {
  const theme = localStorage.getItem('theme') || 'light'
  return <div className={theme}>{children}</div>
}
```

### Mistake 2: useEffect Flicker

```javascript
// Bad: Shows light theme, then flickers to dark
function ThemeWrapper({ children }) {
  const [theme, setTheme] = useState('light')

  useEffect(() => {
    setTheme(localStorage.getItem('theme') || 'light')
  }, [])

  return <div className={theme}>{children}</div>
}
```

User sees: light → flash → dark (FOUC - Flash of Unstyled Content)

---

## Solution: Inline Script Before Hydration

Inject a synchronous script that runs before React hydrates:

```javascript
// app/layout.tsx (Next.js App Router)
export default function RootLayout({ children }) {
  return (
    <html suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                const theme = localStorage.getItem('theme') || 'light';
                document.documentElement.classList.add(theme);
              })();
            `,
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  )
}
```

### Key Points

1. Script runs **before** React hydrates
2. `suppressHydrationWarning` prevents React warnings
3. Apply to `<html>` or `<body>` for immediate effect

---

## Complete Theme Implementation

```javascript
// app/layout.tsx
export default function RootLayout({ children }) {
  return (
    <html suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                function getTheme() {
                  const stored = localStorage.getItem('theme');
                  if (stored) return stored;
                  return window.matchMedia('(prefers-color-scheme: dark)').matches
                    ? 'dark' : 'light';
                }
                document.documentElement.classList.add(getTheme());
              })();
            `,
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  )
}

// components/ThemeToggle.tsx
'use client'

function ThemeToggle() {
  const [theme, setTheme] = useState<string | null>(null)

  useEffect(() => {
    // Read initial theme from DOM (set by inline script)
    const current = document.documentElement.classList.contains('dark')
      ? 'dark' : 'light'
    setTheme(current)
  }, [])

  const toggle = () => {
    const next = theme === 'light' ? 'dark' : 'light'
    document.documentElement.classList.remove('light', 'dark')
    document.documentElement.classList.add(next)
    localStorage.setItem('theme', next)
    setTheme(next)
  }

  // Render nothing until we know the theme
  if (!theme) return null

  return (
    <button onClick={toggle}>
      {theme === 'light' ? '🌙' : '☀️'}
    </button>
  )
}
```

---

## Alternative: CSS-Only Approach

For simpler cases, use CSS media queries without JavaScript:

```css
:root {
  --bg: white;
  --text: black;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #1a1a1a;
    --text: white;
  }
}

/* Override with data attribute when user chooses */
[data-theme="dark"] {
  --bg: #1a1a1a;
  --text: white;
}

[data-theme="light"] {
  --bg: white;
  --text: black;
}
```

---

## When to Use Each Approach

| Scenario | Approach |
|----------|----------|
| System preference only | CSS media queries |
| User toggle with persistence | Inline script |
| Complex theme logic | Inline script + CSS variables |

---

## Related

- [next-themes](https://github.com/pacocoursey/next-themes) - Library that handles this automatically
