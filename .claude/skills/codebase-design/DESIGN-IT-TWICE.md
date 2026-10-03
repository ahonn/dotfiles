# Compare Alternative Interfaces

Use this guide when the user requests alternatives or a consequential interface choice remains uncertain. Follow [SKILL.md](SKILL.md) and use the project's domain language. Routine fixes do not need multiple designs.

## Frame the decision

Identify the caller problem, required behavior, compatibility constraints, dependencies, and ownership. A brief usage example can reveal the contract better than a long abstract proposal. Read [DEEPENING.md](DEEPENING.md) if dependency placement is the unresolved issue.

## Explore meaningful alternatives

Compare approaches with different consequences for callers, lifecycle ownership, error handling, or implementation cost. Do not create artificial variants or add hypothetical features merely to fill a menu.

For complex or high-risk decisions where independent perspectives would help, or when explicitly requested, delegate bounded design briefs to available agents while doing useful local analysis. Otherwise explore the options locally. There is no required agent count or mandatory plugin.

Each useful proposal should make these aspects concrete:

- Caller-facing operations and a representative usage example.
- Invariants, ordering, error modes, and resource ownership.
- Complexity hidden in the implementation and knowledge still required by callers.
- Dependency strategy, migration cost, and how behavior could be verified under the global test mode.

## Recommend and continue

Compare the options by caller simplicity, locality of changes, compatibility, and operational behavior. Recommend the smallest design that meets the established requirements, explaining the tradeoff that determines the choice.

Continue with the recommendation when the session already authorizes the implementation and the decision stays within scope. Ask only for a missing consequential decision or a change that requires approval under global AGENTS.md. Do not add a separate approval gate because alternatives were explored.
