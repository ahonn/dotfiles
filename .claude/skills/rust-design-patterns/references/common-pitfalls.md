# Common Pitfalls

Anti-patterns and common mistakes in Rust code.

## Table of Contents

- [Clone to Satisfy Borrow Checker](#clone-to-satisfy-borrow-checker)
- [deny(warnings) in Libraries](#denywarnings-in-libraries)
- [Deref Polymorphism](#deref-polymorphism)

---

## Clone to Satisfy Borrow Checker

Using `.clone()` as a quick fix for borrow checker errors.

### The Problem

```rust
let mut data = vec![1, 2, 3];

// Borrow checker error
let first = &data[0];
data.push(4);  // Error: cannot borrow as mutable
println!("{}", first);

// "Fix" with clone
let first = data[0].clone();  // Works, but...
data.push(4);
println!("{}", first);
```

### Why It's Bad

1. **Performance**: Cloning heap data (String, Vec) allocates memory
2. **Data sync**: Clone creates independent copy; changes don't propagate
3. **Hides design issues**: Masks problems that should be solved differently

### When Clone IS Appropriate

| Situation | Example |
|-----------|---------|
| Data is cheap to clone | `i32`, `bool`, small structs with `Copy` |
| Shared ownership needed | Use `Rc::clone()` or `Arc::clone()` (cheap) |
| Prototype/learning | Acceptable to prioritize clarity over performance |
| Explicit copy semantics | When you actually need independent copies |

### Better Alternatives

**1. Reorder operations:**
```rust
let mut data = vec![1, 2, 3];
data.push(4);           // Mutate first
let first = &data[0];   // Then borrow
println!("{}", first);
```

**2. Use scopes to limit borrows:**
```rust
let mut data = vec![1, 2, 3];
{
    let first = &data[0];
    println!("{}", first);
}  // Borrow ends here
data.push(4);
```

**3. Use indices instead of references:**
```rust
let mut data = vec![1, 2, 3];
let first_idx = 0;
data.push(4);
println!("{}", data[first_idx]);
```

**4. Use `mem::take` for enum variants:**
```rust
// Instead of cloning to move out of &mut
let owned = mem::take(&mut self.field);
```

**5. Refactor ownership structure:**
```rust
// Instead of cloning everywhere
struct App {
    data: Rc<RefCell<Data>>,  // Shared ownership where needed
}
```

### Detection

Run `cargo clippy` - it warns about many unnecessary clones:
```
warning: using `clone` on type which implements `Copy`
warning: redundant clone
```

---

## deny(warnings) in Libraries

Using `#![deny(warnings)]` in library crate roots.

### The Problem

```rust
// lib.rs
#![deny(warnings)]

pub fn api() { }
```

### Why It's Bad

1. **Breaks on Rust updates**: New warnings in future Rust versions break your users' builds
2. **Breaks with new lints**: Clippy updates add new warnings
3. **Not your decision**: Library consumers should control their warning policy

### Real Example

Rust 1.30 added `overlapping_inherent_impls` warning. Libraries with `deny(warnings)` suddenly failed to compile for users who updated Rust.

### Better Alternatives

**1. Use RUSTFLAGS in CI (recommended):**
```bash
RUSTFLAGS="-D warnings" cargo build
RUSTFLAGS="-D warnings" cargo test
```

**2. Deny specific lints:**
```rust
#![deny(
    missing_docs,
    unsafe_code,
    unused_must_use,
)]
```

**3. Warn by default, deny in CI:**
```toml
# .cargo/config.toml (for CI only)
[build]
rustflags = ["-D", "warnings"]
```

### Safe Lints to Deny

```rust
#![deny(
    // Safety
    unsafe_code,

    // Common mistakes
    unused_must_use,
    unconditional_recursion,

    // Code quality
    missing_docs,
    missing_debug_implementations,
)]
```

### What NOT to Deny

- `deprecated` - APIs get deprecated, shouldn't break builds
- `warnings` - Too broad, includes future unknown warnings

---

## Deref Polymorphism

Misusing `Deref` trait to emulate OOP inheritance.

### The Anti-Pattern

```rust
struct Foo {
    value: i32,
}

impl Foo {
    fn foo_method(&self) -> i32 {
        self.value
    }
}

struct Bar {
    foo: Foo,  // "Inherit" from Foo
}

impl Deref for Bar {
    type Target = Foo;

    fn deref(&self) -> &Foo {
        &self.foo
    }
}

// Now Bar can use Foo's methods
let bar = Bar { foo: Foo { value: 42 } };
bar.foo_method();  // Works through Deref
```

### Why It's Bad

**1. Surprising behavior:**
```rust
// What type is this?
let x = *bar;  // Dereferencing Bar gives... Foo?
```

**2. No true subtyping:**
```rust
fn takes_foo(f: &Foo) { }
fn takes_bar(b: &Bar) { }

takes_foo(&bar);  // Works (Deref coercion)
// But Bar is not a Foo - no Liskov substitution
```

**3. Traits don't transfer:**
```rust
impl Debug for Foo { /* ... */ }

// Bar doesn't automatically implement Debug
// Even though it Derefs to Foo
```

**4. Breaks generic code:**
```rust
fn generic<T: Debug>(t: &T) { }

generic(&bar);  // Error: Bar doesn't implement Debug
```

**5. `self` semantics differ:**
```rust
impl Foo {
    fn get_self(&self) -> &Self {
        self  // Returns &Foo, even when called through Bar
    }
}
```

### When Deref IS Appropriate

| Use Case | Example |
|----------|---------|
| Smart pointers | `Box<T>`, `Rc<T>`, `Arc<T>` |
| Wrapper types that ARE the inner type | `String` → `str`, `Vec<T>` → `[T]` |
| Newtype with full delegation | When wrapper should be transparent |

### Better Alternatives

**1. Explicit delegation:**
```rust
impl Bar {
    fn foo_method(&self) -> i32 {
        self.foo.foo_method()
    }
}
```

**2. Use traits for shared behavior:**
```rust
trait HasValue {
    fn value(&self) -> i32;
}

impl HasValue for Foo { /* ... */ }
impl HasValue for Bar { /* ... */ }
```

**3. Composition with `AsRef`:**
```rust
impl AsRef<Foo> for Bar {
    fn as_ref(&self) -> &Foo {
        &self.foo
    }
}

fn process(f: impl AsRef<Foo>) {
    let foo = f.as_ref();
    // ...
}
```

**4. Use delegation crates:**
- `delegate` crate
- `ambassador` crate
- `derive_more` with `Deref` (when appropriate)

### The Rule

`Deref` should represent a pointer-like relationship where the wrapper IS-A smart pointer to the target, not where the wrapper HAS-A field of the target type.
