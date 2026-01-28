# Ownership Patterns

Patterns for working with Rust's ownership system and borrow checker.

## Table of Contents

- [mem::take and mem::replace](#memtake-and-memreplace)
- [Struct Decomposition](#struct-decomposition)
- [RAII Guards](#raii-guards)
- [Rc/Arc Decision Guide](#rcarc-decision-guide)
- [Finalisation in Destructors](#finalisation-in-destructors)

---

## mem::take and mem::replace

Move owned values out of `&mut` references without cloning.

### Problem

```rust
enum MyEnum {
    A { name: String, x: u8 },
    B { name: String },
}

fn a_to_b(e: &mut MyEnum) {
    if let MyEnum::A { name, x: 0 } = e {
        // Error: cannot move out of borrowed content
        *e = MyEnum::B { name: name };
    }
}
```

### Solution

```rust
use std::mem;

fn a_to_b(e: &mut MyEnum) {
    if let MyEnum::A { name, x: 0 } = e {
        // Replace with default, get owned value
        *e = MyEnum::B {
            name: mem::take(name),  // takes String, leaves empty String
        };
    }
}
```

### When to Use

| Function | Use When |
|----------|----------|
| `mem::take(x)` | Type implements `Default`, want to leave default value |
| `mem::replace(x, value)` | Need to specify replacement value |
| `Option::take()` | Working with `Option`, want to leave `None` |

### Example: Swizzling Enum Variants

```rust
fn swizzle(e: &mut MultiVariateEnum) {
    use MultiVariateEnum::*;
    *e = match e {
        A { name } => B { name: mem::take(name) },
        B { name } => A { name: mem::take(name) },
        C => D,
        D => C,
    }
}
```

**Key insight**: Like Indiana Jones replacing artifact with sand bag - must leave something behind when taking ownership.

---

## Struct Decomposition

Break large structs into smaller ones for independent field borrowing.

### Problem

```rust
struct Database {
    connection: Connection,
    cache: Cache,
    config: Config,
}

impl Database {
    fn process(&mut self) {
        let conn = &mut self.connection;
        self.log_to_cache();  // Error: self already borrowed
    }

    fn log_to_cache(&mut self) { /* ... */ }
}
```

### Solution

```rust
struct Database {
    connection: Connection,
    cache: Cache,
    config: Config,
}

impl Database {
    fn process(&mut self) {
        // Borrow fields independently
        let conn = &mut self.connection;
        let cache = &mut self.cache;

        // Or decompose into method that takes specific fields
        Self::log(cache, "message");
    }

    fn log(cache: &mut Cache, msg: &str) { /* ... */ }
}
```

### Alternative: Decompose into Sub-structs

```rust
struct ConnectionManager {
    connection: Connection,
    pool_size: u32,
}

struct CacheManager {
    cache: Cache,
    ttl: Duration,
}

struct Database {
    conn: ConnectionManager,
    cache: CacheManager,
}

// Now can borrow conn and cache independently
fn process(db: &mut Database) {
    let conn = &mut db.conn;
    let cache = &mut db.cache;  // OK: different fields
}
```

**When to use**: Large structs where methods need to borrow different fields simultaneously.

---

## RAII Guards

Use guard objects to ensure cleanup runs on scope exit.

### Pattern

```rust
struct MutexGuard<'a, T> {
    data: &'a mut T,
    lock: &'a Mutex<T>,
}

impl<'a, T> Drop for MutexGuard<'a, T> {
    fn drop(&mut self) {
        self.lock.unlock();
    }
}

impl<'a, T> Deref for MutexGuard<'a, T> {
    type Target = T;
    fn deref(&self) -> &T {
        self.data
    }
}
```

### Usage Benefits

```rust
fn critical_section(mutex: &Mutex<Data>) -> Result<()> {
    let guard = mutex.lock();

    // Multiple exit points - all safe
    if guard.is_invalid() {
        return Err(Error::Invalid);  // guard dropped, mutex unlocked
    }

    process(&guard)?;  // ? may return early, guard still dropped

    Ok(())
}  // guard dropped here in normal case
```

### Key Properties

1. **Borrow checker integration**: Guard holds reference to resource, preventing use-after-free
2. **Automatic cleanup**: Drop runs on any exit (return, ?, panic)
3. **Deref for ergonomics**: Access inner data through guard transparently

**Caveat**: Destructors not guaranteed in double-panic or infinite loop.

---

## Rc/Arc Decision Guide

When to use reference counting vs refactoring ownership.

### Decision Flow

```
Need shared ownership?
├── No → Use references (&T, &mut T)
│
├── Yes, single thread?
│   ├── Immutable sharing → Rc<T>
│   └── Need mutation → Rc<RefCell<T>>
│
└── Yes, multiple threads?
    ├── Immutable sharing → Arc<T>
    └── Need mutation → Arc<Mutex<T>> or Arc<RwLock<T>>
```

### When Rc/Arc is Appropriate

- Graph structures with cycles (use `Weak` for back-references)
- Multiple owners truly needed (not just convenience)
- Cloning underlying data is expensive

### When to Refactor Instead

```rust
// Bad: using Rc to avoid borrow checker
let data = Rc::new(vec![1, 2, 3]);
let data_clone = Rc::clone(&data);
process(data_clone);  // Just to satisfy borrow checker

// Good: pass reference
let data = vec![1, 2, 3];
process(&data);
```

**Rule**: If you're cloning `Rc`/`Arc` just to satisfy the borrow checker (not for true shared ownership), refactor the code structure instead.

---

## Finalisation in Destructors

Use Drop as Rust's equivalent to `finally` blocks.

### Pattern

```rust
fn with_cleanup() -> Result<(), Error> {
    struct Cleanup;
    impl Drop for Cleanup {
        fn drop(&mut self) {
            println!("cleanup runs on any exit");
        }
    }

    let _cleanup = Cleanup;

    risky_operation()?;  // Early return? Cleanup runs.
    another_operation()?;

    Ok(())
}  // Cleanup runs here too
```

### Important Naming

```rust
let _guard = Cleanup;   // Correct: lives until scope end
let _ = Cleanup;        // Wrong: dropped immediately!
```

### Caveats

1. **Not guaranteed**: Won't run if thread panics during another panic
2. **No panic in Drop**: Panicking in destructor during unwinding aborts
3. **Implicit code**: Can make debugging harder

**Best practice**: Keep Drop implementations simple and infallible.

---

## Contain Unsafety in Small Modules

Isolate unsafe code in minimal modules with safe interfaces.

### Pattern

```rust
// Internal module with unsafe implementation
mod raw {
    // Minimal unsafe code with clear invariants
    pub unsafe fn dangerous_operation(ptr: *mut u8) {
        // ...
    }
}

// Outer module provides safe interface
pub struct SafeWrapper {
    data: Vec<u8>,
}

impl SafeWrapper {
    pub fn new() -> Self {
        Self { data: Vec::new() }
    }

    pub fn safe_operation(&mut self) {
        // Maintain invariants, then call unsafe
        if !self.data.is_empty() {
            unsafe {
                raw::dangerous_operation(self.data.as_mut_ptr());
            }
        }
    }
}
```

### Principles

1. **Minimal unsafe surface**: Only the code that truly needs `unsafe` should be unsafe
2. **Clear invariants**: Document what must be true for the unsafe code to be sound
3. **Safe wrapper**: Expose ergonomic safe API that upholds invariants
4. **Optional unsafe escape hatch**: May provide `unsafe` methods for performance

### Real-World Example

```rust
// std::String is a safe wrapper around Vec<u8>
// Invariant: contents must be valid UTF-8

impl String {
    // Safe: validates UTF-8
    pub fn from_utf8(vec: Vec<u8>) -> Result<String, FromUtf8Error> {
        // ...
    }

    // Unsafe escape hatch: caller must ensure UTF-8
    pub unsafe fn from_utf8_unchecked(bytes: Vec<u8>) -> String {
        // ...
    }
}
```

### Benefits

| Benefit | Description |
|---------|-------------|
| Restricted auditing | Only small module needs careful review |
| Easier development | Outer module can trust inner guarantees |
| Clear boundaries | Safe/unsafe distinction is explicit |

### When to Use

- FFI wrappers
- Low-level data structures
- Performance-critical code requiring unsafe
- Any code with `unsafe` blocks
