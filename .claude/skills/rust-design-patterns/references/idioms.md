# Small Idioms

Narrow, self-contained idioms that solve a single mechanical problem. Each is
independent — read only the one that matches the situation.

## Table of Contents

- [On-Stack Dynamic Dispatch](#on-stack-dynamic-dispatch)
- [Option as Iterator](#option-as-iterator)
- [Closure Capture Control](#closure-capture-control)
- [Temporary Mutability](#temporary-mutability)
- [Return Consumed Argument on Error](#return-consumed-argument-on-error)

---

## On-Stack Dynamic Dispatch

Avoid heap allocation for trait objects:

```rust
use std::io::{self, Read};

fn process(use_stdin: bool) -> io::Result<String> {
    let readable: &mut dyn Read = if use_stdin {
        &mut io::stdin()
    } else {
        &mut std::fs::File::open("input.txt")?
    };

    let mut buf = String::new();
    readable.read_to_string(&mut buf)?;
    Ok(buf)
}
```

**When**: Need dynamic dispatch without Box allocation. Since Rust 1.79, lifetime extension makes this ergonomic.

## Option as Iterator

`Option` implements `IntoIterator` (0 or 1 element):

```rust
let maybe_name = Some("Turing");
let mut names = vec!["Curry", "Kleene"];

// Extend with Option
names.extend(maybe_name);

// Chain with Option
for name in names.iter().chain(maybe_name.iter()) {
    println!("{name}");
}
```

**Tip**: For always-`Some`, prefer `std::iter::once(value)`.

## Closure Capture Control

Control what closures capture via rebinding:

```rust
use std::rc::Rc;

let num1 = Rc::new(1);
let num2 = Rc::new(2);

let closure = {
    let num2 = num2.clone();  // clone before move
    let num1 = num1.as_ref(); // borrow
    move || { *num1 + *num2 }
};
// num1 still usable, num2 was cloned
```

## Temporary Mutability

Make variable immutable after setup:

```rust
// Method 1: Nested block
let data = {
    let mut data = get_vec();
    data.sort();
    data
};
// data is immutable here

// Method 2: Rebinding
let mut data = get_vec();
data.sort();
let data = data;  // now immutable
```

## Return Consumed Argument on Error

If function consumes argument, return it in error for retry:

```rust
pub struct SendError(pub String);  // contains the original value

pub fn send(value: String) -> Result<(), SendError> {
    if can_send() {
        do_send(&value);
        Ok(())
    } else {
        Err(SendError(value))  // caller can retry
    }
}

// Usage: retry loop without clone
let mut msg = "hello".to_string();
loop {
    match send(msg) {
        Ok(()) => break,
        Err(SendError(m)) => { msg = m; }  // recover and retry
    }
}
```

**Example**: `String::from_utf8` returns `FromUtf8Error` containing original `Vec<u8>`.

