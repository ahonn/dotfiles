# API Design Patterns

Patterns for designing idiomatic Rust APIs.

## Table of Contents

- [Borrowed Types for Arguments](#borrowed-types-for-arguments)
- [Builder Pattern](#builder-pattern)
- [Newtype Pattern](#newtype-pattern)
- [Default Trait](#default-trait)
- [Constructor Conventions](#constructor-conventions)
- [Collections as Smart Pointers](#collections-as-smart-pointers)
- [non_exhaustive for Extensibility](#non_exhaustive-for-extensibility)
- [Type State Pattern](#type-state-pattern)
- [FFI Patterns](#ffi-patterns)

---

## Borrowed Types for Arguments

Use deref targets (`&str`, `&[T]`, `&Path`) instead of owned references (`&String`, `&Vec<T>`, `&PathBuf`).

### The Rule

| Instead of | Use |
|------------|-----|
| `&String` | `&str` |
| `&Vec<T>` | `&[T]` |
| `&PathBuf` | `&Path` |
| `&Box<T>` | `&T` |

### Why

```rust
fn with_string(s: &String) { }
fn with_str(s: &str) { }

let owned = String::from("hello");
let literal = "world";
let slice = &owned[0..3];

// &String: only accepts &String
with_string(&owned);     // OK
// with_string(literal);  // Error
// with_string(slice);    // Error

// &str: accepts all string types
with_str(&owned);        // OK (deref coercion)
with_str(literal);       // OK
with_str(slice);         // OK
```

### Performance Benefit

`&String` has two levels of indirection (pointer to String, String points to heap). `&str` has one (direct pointer to string data).

### Exception

Use `&String` or `&Vec<T>` only when you need methods specific to the owned type (e.g., `capacity()`).

---

## Builder Pattern

For types with many optional configuration parameters.

### Basic Pattern

```rust
pub struct Server {
    host: String,
    port: u16,
    max_connections: usize,
    timeout: Duration,
}

#[derive(Default)]
pub struct ServerBuilder {
    host: String,
    port: u16,
    max_connections: Option<usize>,
    timeout: Option<Duration>,
}

impl ServerBuilder {
    pub fn new(host: impl Into<String>, port: u16) -> Self {
        Self {
            host: host.into(),
            port,
            ..Default::default()
        }
    }

    pub fn max_connections(mut self, n: usize) -> Self {
        self.max_connections = Some(n);
        self
    }

    pub fn timeout(mut self, d: Duration) -> Self {
        self.timeout = Some(d);
        self
    }

    pub fn build(self) -> Server {
        Server {
            host: self.host,
            port: self.port,
            max_connections: self.max_connections.unwrap_or(100),
            timeout: self.timeout.unwrap_or(Duration::from_secs(30)),
        }
    }
}

// Usage
let server = ServerBuilder::new("localhost", 8080)
    .max_connections(500)
    .build();
```

### Variant: Mutable Reference

```rust
impl ServerBuilder {
    pub fn max_connections(&mut self, n: usize) -> &mut Self {
        self.max_connections = Some(n);
        self
    }
}

// Allows reuse
let mut builder = ServerBuilder::new("localhost", 8080);
builder.max_connections(500);
builder.timeout(Duration::from_secs(60));
let server = builder.build();
```

### When to Use

- Many optional parameters
- Construction has validation or side effects
- Want to provide discovery through methods (IDE autocomplete)
- Object configuration may be reused (template pattern)

### Real-World Examples

- `std::process::Command`
- `reqwest::ClientBuilder`
- `tokio::runtime::Builder`

---

## Newtype Pattern

Wrap types in single-field tuple structs for type safety.

### Type Safety

```rust
struct Miles(f64);
struct Kilometers(f64);

fn travel_distance(miles: Miles) -> Kilometers {
    Kilometers(miles.0 * 1.60934)
}

let m = Miles(100.0);
// travel_distance(Kilometers(100.0));  // Compile error!
```

### Abstraction / Encapsulation

```rust
pub struct Password(String);

impl Password {
    pub fn new(s: impl Into<String>) -> Result<Self, &'static str> {
        let s = s.into();
        if s.len() >= 8 {
            Ok(Password(s))
        } else {
            Err("password too short")
        }
    }
}

// Display without revealing content
impl std::fmt::Display for Password {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "********")
    }
}
```

### Implementing Traits on Foreign Types

```rust
// Can't impl Display for Vec<T> directly (orphan rule)
struct Wrapper(Vec<String>);

impl std::fmt::Display for Wrapper {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}
```

### Reducing Boilerplate

Use `derive_more` crate for automatic trait delegation:

```rust
use derive_more::{From, Into, Deref, DerefMut};

#[derive(From, Into, Deref, DerefMut)]
struct UserId(u64);
```

---

## Default Trait

Provide standard default values for types.

### Derive When Possible

```rust
#[derive(Default)]
struct Config {
    host: String,           // ""
    port: u16,              // 0
    enabled: bool,          // false
    items: Vec<String>,     // vec![]
    optional: Option<i32>,  // None
}
```

### Custom Implementation

```rust
struct Config {
    host: String,
    port: u16,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            host: "localhost".to_string(),
            port: 8080,
        }
    }
}
```

### Struct Update Syntax

```rust
let config = Config {
    port: 3000,
    ..Default::default()  // host = "localhost"
};
```

### Convention

If type has `Default`, also provide `new()` when it makes sense:

```rust
impl Config {
    pub fn new() -> Self {
        Self::default()
    }
}
```

---

## Constructor Conventions

Rust uses associated functions instead of language-level constructors.

### Standard Names

| Name | Use |
|------|-----|
| `new()` | Primary constructor |
| `with_capacity(n)` | Pre-allocate space |
| `from_*()` | Convert from specific type |
| `default()` | Default trait |

### Fallible Construction

```rust
impl Config {
    pub fn new() -> Self { /* ... */ }

    // Fallible version
    pub fn try_new(path: &Path) -> Result<Self, ConfigError> { /* ... */ }

    // Or use TryFrom
}

impl TryFrom<&Path> for Config {
    type Error = ConfigError;

    fn try_from(path: &Path) -> Result<Self, Self::Error> { /* ... */ }
}
```

---

## Collections as Smart Pointers

Collections implement `Deref` to their borrowed view.

### Relationship

| Owned | Borrowed |
|-------|----------|
| `Vec<T>` | `&[T]` |
| `String` | `&str` |
| `PathBuf` | `&Path` |
| `OsString` | `&OsStr` |
| `CString` | `&CStr` |

### Implications

```rust
// Methods on &[T] are available on Vec<T>
let v = vec![1, 2, 3];
v.first();       // Method on &[T], works through Deref

// Functions taking &[T] accept &Vec<T>
fn process(slice: &[i32]) { }
process(&v);     // Deref coercion
```

### Custom Collections

```rust
struct MyVec<T> {
    data: Vec<T>,
}

impl<T> Deref for MyVec<T> {
    type Target = [T];

    fn deref(&self) -> &[T] {
        &self.data
    }
}
```

---

## non_exhaustive for Extensibility

Mark enums and structs to allow future additions without breaking changes.

### For Enums

```rust
#[non_exhaustive]
pub enum Error {
    NotFound,
    PermissionDenied,
    // Future versions can add variants
}

// Users must handle unknown variants
match error {
    Error::NotFound => { /* ... */ }
    Error::PermissionDenied => { /* ... */ }
    _ => { /* handle future variants */ }  // Required!
}
```

### For Structs

```rust
#[non_exhaustive]
pub struct Config {
    pub name: String,
    pub value: i32,
    // Future versions can add fields
}

// Users cannot use struct literal syntax
// let c = Config { name: "x".into(), value: 1 };  // Error!

// Must use constructor or builder
impl Config {
    pub fn new(name: impl Into<String>, value: i32) -> Self {
        Self { name: name.into(), value }
    }
}
```

### When to Use

| Use Case | Benefit |
|----------|---------|
| Public error types | Add new error variants in minor versions |
| Configuration structs | Add optional fields without breaking |
| API response types | Extend responses in minor versions |

### Caveats

- Only affects external crates; within your crate, exhaustive matching still works
- Forces users to have catch-all arms, reducing match ergonomics
- Use sparingly - only for types you expect to evolve

---

## Type State Pattern

Encode state machines in the type system for compile-time correctness.

### Basic Pattern

```rust
// Marker types for states
struct Draft;
struct Published;

struct Post<State> {
    content: String,
    _state: std::marker::PhantomData<State>,
}

impl Post<Draft> {
    fn new(content: String) -> Self {
        Post { content, _state: std::marker::PhantomData }
    }

    // Consumes Draft, returns Published
    fn publish(self) -> Post<Published> {
        Post { content: self.content, _state: std::marker::PhantomData }
    }
}

impl Post<Published> {
    fn view(&self) -> &str {
        &self.content
    }
}

// Usage
let draft = Post::new("Hello".into());
// draft.view();  // Compile error! Draft has no view()
let published = draft.publish();
published.view();  // OK
// draft.publish();  // Compile error! draft was moved
```

### With Sealed Traits

```rust
mod private {
    pub trait Sealed {}
}

pub trait State: private::Sealed {}

pub struct Open;
pub struct Closed;

impl private::Sealed for Open {}
impl private::Sealed for Closed {}
impl State for Open {}
impl State for Closed {}

pub struct Connection<S: State> {
    _state: std::marker::PhantomData<S>,
}

impl Connection<Closed> {
    pub fn open(self) -> Connection<Open> {
        Connection { _state: std::marker::PhantomData }
    }
}

impl Connection<Open> {
    pub fn send(&self, data: &[u8]) { /* ... */ }

    pub fn close(self) -> Connection<Closed> {
        Connection { _state: std::marker::PhantomData }
    }
}
```

### When to Use

- Protocol implementations (HTTP request building, database transactions)
- Resource lifecycle management (file handles, connections)
- Multi-step processes where order matters
- Anything with distinct states and valid transitions

### Benefits

| Benefit | Description |
|---------|-------------|
| Compile-time safety | Invalid state transitions are type errors |
| Zero runtime cost | PhantomData is zero-sized |
| Self-documenting | Type signatures show valid operations |
| Impossible to misuse | API guides users to correct usage |

### Trade-offs

- More complex type signatures
- Harder to store heterogeneous states in collections
- Learning curve for API consumers

---

## FFI Patterns

### Error Handling

```rust
#[repr(C)]
pub enum ErrorCode {
    Success = 0,
    InvalidInput = 1,
    IoError = 2,
    Unknown = 99,
}

#[no_mangle]
pub extern "C" fn process_data(ptr: *const u8, len: usize) -> ErrorCode {
    if ptr.is_null() {
        return ErrorCode::InvalidInput;
    }
    // ...
    ErrorCode::Success
}

// Detailed error description
#[no_mangle]
pub extern "C" fn get_last_error() -> *const c_char {
    // Return pointer to thread-local error string
}
```

### String Handling

```rust
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

// Accepting strings from C
#[no_mangle]
pub unsafe extern "C" fn process_string(s: *const c_char) {
    if s.is_null() { return; }

    let c_str = unsafe { CStr::from_ptr(s) };
    if let Ok(rust_str) = c_str.to_str() {
        // Use rust_str...
    }
}

// Returning strings to C
#[no_mangle]
pub extern "C" fn get_name() -> *mut c_char {
    let s = CString::new("hello").unwrap();
    s.into_raw()  // Caller must free with free_string()
}

#[no_mangle]
pub unsafe extern "C" fn free_string(s: *mut c_char) {
    if !s.is_null() {
        drop(unsafe { CString::from_raw(s) });
    }
}
```

### Opaque Types

```rust
pub struct Database { /* internal fields */ }

#[no_mangle]
pub extern "C" fn db_open(path: *const c_char) -> *mut Database {
    // Create and return opaque pointer
    Box::into_raw(Box::new(Database::new()))
}

#[no_mangle]
pub unsafe extern "C" fn db_close(db: *mut Database) {
    if !db.is_null() {
        drop(unsafe { Box::from_raw(db) });
    }
}
```
