# Re-render: Context Splitting

**Priority**: HIGH
**Impact**: Avoid unnecessary re-renders
**Applies to**: Context API usage, Global state

---

## The Problem

Single context causes all consumers to re-render on any change:

```javascript
// Bad: Single context with everything
const AppContext = createContext(null);

function Provider({ children }) {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');
  const [notifications, setNotifications] = useState([]);

  // Every state change re-renders ALL consumers
  return (
    <AppContext value={{ user, setUser, theme, setTheme, notifications, setNotifications }}>
      {children}
    </AppContext>
  );
}
```

---

## Solution: Split Contexts

### Pattern 1: Separate by Domain

```javascript
const UserContext = createContext(null);
const ThemeContext = createContext(null);
const NotificationContext = createContext(null);

function Providers({ children }) {
  return (
    <UserProvider>
      <ThemeProvider>
        <NotificationProvider>
          {children}
        </NotificationProvider>
      </ThemeProvider>
    </UserProvider>
  );
}
```

### Pattern 2: Split State and Dispatch

```javascript
const StateContext = createContext(null);
const DispatchContext = createContext(null);

function Provider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <StateContext value={state}>
      <DispatchContext value={dispatch}>
        {children}
      </DispatchContext>
    </StateContext>
  );
}

// Components that only dispatch don't re-render on state changes
function ActionButton() {
  const dispatch = useContext(DispatchContext);
  // dispatch is stable - this component never re-renders due to context
  return <button onClick={() => dispatch({ type: 'increment' })}>+</button>;
}

// Components that read state re-render only when state changes
function Display() {
  const state = useContext(StateContext);
  return <span>{state.count}</span>;
}
```

---

## Complete Example

```javascript
// contexts/TasksContext.js
import { createContext, useContext, useReducer } from 'react';

const TasksContext = createContext(null);
const TasksDispatchContext = createContext(null);

function tasksReducer(tasks, action) {
  switch (action.type) {
    case 'add':
      return [...tasks, { id: Date.now(), text: action.text, done: false }];
    case 'toggle':
      return tasks.map(t => t.id === action.id ? { ...t, done: !t.done } : t);
    case 'delete':
      return tasks.filter(t => t.id !== action.id);
    default:
      throw new Error(`Unknown action: ${action.type}`);
  }
}

export function TasksProvider({ children }) {
  const [tasks, dispatch] = useReducer(tasksReducer, []);

  return (
    <TasksContext value={tasks}>
      <TasksDispatchContext value={dispatch}>
        {children}
      </TasksDispatchContext>
    </TasksContext>
  );
}

// Custom hooks for clean API
export function useTasks() {
  const context = useContext(TasksContext);
  if (context === null) {
    throw new Error('useTasks must be used within TasksProvider');
  }
  return context;
}

export function useTasksDispatch() {
  const context = useContext(TasksDispatchContext);
  if (context === null) {
    throw new Error('useTasksDispatch must be used within TasksProvider');
  }
  return context;
}
```

```javascript
// Usage
function TaskList() {
  const tasks = useTasks(); // Re-renders when tasks change
  return tasks.map(task => <TaskItem key={task.id} task={task} />);
}

function AddTaskForm() {
  const dispatch = useTasksDispatch(); // Never re-renders from context
  const [text, setText] = useState('');

  const handleSubmit = () => {
    dispatch({ type: 'add', text });
    setText('');
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={text} onChange={e => setText(e.target.value)} />
      <button type="submit">Add</button>
    </form>
  );
}
```

---

## Advanced: Selective Subscriptions

For fine-grained control, use selectors with useSyncExternalStore or state libraries:

```javascript
// With Zustand
const useStore = create((set) => ({
  user: null,
  theme: 'light',
  setUser: (user) => set({ user }),
  setTheme: (theme) => set({ theme })
}));

// Select only what you need
function UserName() {
  const userName = useStore(state => state.user?.name);
  // Only re-renders when user.name changes
  return <span>{userName}</span>;
}

function ThemeToggle() {
  const theme = useStore(state => state.theme);
  const setTheme = useStore(state => state.setTheme);
  // Only re-renders when theme changes
  return <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
    Toggle
  </button>;
}
```

---

## When to Split

| Scenario | Recommendation |
|----------|----------------|
| Small app, few consumers | Single context is fine |
| Many components reading same data | Split by domain |
| Some components only dispatch | Split state/dispatch |
| Fine-grained updates needed | Use state library |

---

## Related Rules

- [rerender-memo-strategy.md](rerender-memo-strategy.md)
