# Research for Reuse Decisions

Use this reference when choosing between an existing abstraction, a dependency, and a new implementation.

## Evidence to Gather

- **Existing callers:** Does the current abstraction serve the same behavior and lifecycle, or only have a similar name?
- **Contract fit:** Which required behaviors are supported, and which would need adaptation? A percentage of matching features does not establish suitability.
- **Dependency cost:** Consider compatibility, ownership, deployment constraints, and ongoing maintenance alongside implementation effort.
- **Reversibility:** Can the choice remain behind a small interface, or will callers become tied to implementation details?

| Finding | Candidate approach |
|---------|--------------------|
| Existing code meets the contract | Reuse it and verify the new caller's assumptions. |
| A small extension fits the abstraction's purpose | Extend it without making unrelated callers understand the new use case. |
| A dependency provides substantial relevant behavior | Check version compatibility and project dependency conventions. |
| Existing options impose more complexity than they remove | Implement the required behavior locally and record non-obvious tradeoffs. |

## When to Revisit an Assumption

Follow evidence that could change the decision: a conflicting caller, an unsupported installed API, an unexplained failure, or an unhandled lifecycle. Search for the missing fact rather than performing a fixed number of searches.

Stop researching when the remaining uncertainty does not affect the next reversible step. If a necessary fact cannot be obtained locally, state the gap and seek the specific information needed.
