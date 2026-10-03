---
name: codebase-design
description: Design or refactor module interfaces to hide complexity, reduce caller coupling, and clarify dependency ownership.
---

# Codebase Design

Design modules that hide substantial behavior behind interfaces callers can understand. Judge a design by the knowledge and coordination it removes from callers, not by file counts or implementation length.

Use the project's established domain language. The vocabulary below supports reasoning; it does not forbid terms such as component, service, API, or boundary.

## Working vocabulary

- **Module**: Code with an interface and an implementation, from a function to a package or feature.
- **Interface**: Everything callers must know: inputs, outputs, invariants, ordering, errors, configuration, and relevant performance constraints.
- **Depth**: Useful behavior exposed relative to the complexity callers must understand.
- **Seam**: A place where behavior can be substituted without editing its consumers.
- **Adapter**: A concrete implementation that connects a dependency at a seam.
- **Locality**: Related decisions and changes stay together instead of spreading across callers.

## Design from the actual problem

Inspect callers, implementation, and dependencies before proposing a new interface. Identify the concrete cost: repeated policy, change amplification, unclear ownership, or difficult verification. Keep the existing design when a new abstraction would add more navigation or coordination than it removes.

- Hide implementation decisions and maintain invariants inside the module that owns them.
- Keep callers' common operations straightforward. Fewer methods are useful only when they reduce the contract callers must learn.
- Keep related behavior together. Do not split a coherent function or file merely to satisfy size targets.
- Introduce dependency injection where substitution, side-effect control, or an existing architectural boundary provides a concrete benefit. Do not invent a second adapter to justify an interface.
- Keep internal dependencies private unless callers need to supply or configure them.
- Prefer pure computation for domain decisions and explicit ownership for effects. An orchestration module may legitimately perform I/O.
- Consider removing a pass-through layer when it contributes no policy, isolation, or stable contract. A thin adapter may still be valuable for an external dependency.

## Validation and completion

Follow global AGENTS.md for test mode and authorization. Design for observable behavior through stable contracts, without forcing all tests through one large public interface or discarding useful focused coverage. Preserve existing behavior and callers unless the task authorizes a contract change.

Explain the resulting caller contract, the complexity it hides, meaningful tradeoffs, and validation performed. Compare alternatives only when they differ materially; do not require multiple designs or independent reviewers for routine changes.

## Read only when relevant

- For consolidating a cluster and choosing dependency seams, read [DEEPENING.md](DEEPENING.md).
- For an explicit alternative-design exploration or a consequential unresolved interface choice, read [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md).
