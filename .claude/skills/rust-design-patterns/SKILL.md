---
name: rust-design-patterns
description: Resolve Rust ownership and lifetime problems or design Rust APIs, resource lifecycles, and FFI boundaries.
user-invocable: false
---

# Rust Design Patterns

Start from the compiler error, API decision, or code under review. Read only the reference sections that match; the catalog is not a checklist to apply everywhere.

## Establish applicability

- Check the crate's edition, MSRV, and whether it is a library or binary. Library crates carry compatibility constraints (`non_exhaustive`, lint policy, public types) that binaries do not.
- Follow the crate's existing conventions for errors, builders, and unsafe boundaries before introducing a new pattern.
- For borrow checker errors, reshape ownership before reaching for `clone`, `Rc`, or `Arc`. Treat a clone as a deliberate cost, not a way to silence the compiler.
- When a lifetime is too short and no borrow reshaping fits, prefer an owned type over widening lifetimes or adding `'static` bounds.

## Read by problem

| Problem or decision | Reference |
|---------------------|-----------|
| Move a value out of `&mut`, or swap enum variants | [ownership-patterns.md](references/ownership-patterns.md) — mem::take and mem::replace |
| Borrow two fields of a struct independently | [ownership-patterns.md](references/ownership-patterns.md) — Struct Decomposition |
| Choosing shared ownership, or tempted to clone | [ownership-patterns.md](references/ownership-patterns.md) — Rc/Arc Decision Guide |
| Guaranteed cleanup (locks, files, transactions) | [ownership-patterns.md](references/ownership-patterns.md) — RAII Guards, Finalisation in Destructors |
| Unsafe code needs a safe boundary | [ownership-patterns.md](references/ownership-patterns.md) — Contain Unsafety in Small Modules |
| Function parameter types (`&str` vs `&String`) | [api-design.md](references/api-design.md) — Borrowed Types for Arguments |
| Many optional constructor parameters | [api-design.md](references/api-design.md) — Builder Pattern, Default Trait |
| Distinct types over the same representation | [api-design.md](references/api-design.md) — Newtype Pattern |
| Compile-time state transitions | [api-design.md](references/api-design.md) — Type State Pattern |
| Public types that must evolve without breaking callers | [api-design.md](references/api-design.md) — non_exhaustive, Constructor Conventions |
| FFI errors, strings, or object lifetimes | [api-design.md](references/api-design.md) — FFI Patterns |
| Dynamic dispatch without boxing | [idioms.md](references/idioms.md) — On-Stack Dynamic Dispatch |
| Closure captures, post-setup immutability, `Option` in iterator chains | [idioms.md](references/idioms.md) |
| A consuming call fails and the caller needs the value back | [idioms.md](references/idioms.md) — Return Consumed Argument on Error |
| Reviewing existing Rust for common mistakes | [common-pitfalls.md](references/common-pitfalls.md) — start with Review Checklist |

Examples illustrate the shape of a pattern, not code to paste. Verify version-sensitive behavior against the crate's toolchain.

## Complete the change

Use the applicable AGENTS.md test mode. `cargo clippy` flags most of the unnecessary clones and borrowed-type issues these references describe.
