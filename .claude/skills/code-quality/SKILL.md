---
name: code-quality
description: "Code quality standards. Defines complexity management, modular design, code smell detection, comment standards. Applied automatically when writing or reviewing code. Invoke directly to clean up comments in a file. Triggers on: 'clean up comments', 'comment cleanup', '/code-quality'."
argument-hint: "[file_path]"
---

# Programming Philosophy and Quality Standards

## Core Philosophy

- Code is primarily written for humans to read and maintain; machine execution is a by-product
- Priority: **Readability & Maintainability > Correctness > Performance > Code length**
- Follow idiomatic practices of each language community

## Complexity Management

```
Complexity = Dependencies + Obscurity
```

### Symptoms to Watch For

| Symptom | Description |
|---------|-------------|
| **Change Amplification** | Small changes require modifications in many places |
| **Cognitive Load** | Developers need excessive information to complete tasks |
| **Unknown Unknowns** | Unclear what code needs modification (worst symptom) |

### Mitigation Strategies

- "Zero tolerance" for incremental complexity growth
- Invest time upfront in design
- Avoid tactical shortcuts that create technical debt

## Modular Design Principles

- **Deep Modules**: Powerful functionality through simple interfaces
- **Information Hiding**: Encapsulate design decisions within implementations
- **General-Purpose Design**: Combat over-specialization
- **Avoid "Classitis"**: More classes/components ≠ better design

## Code Smells to Watch For

Proactively identify and flag:
- Duplicated logic / copy-paste code
- Over-tight coupling or circular dependencies
- Fragile designs where one change breaks unrelated parts
- Unclear intent, confused abstractions, vague naming
- Over-engineering without real benefit

When identifying code smells:
- Explain the problem concisely
- Provide 1–2 refactoring directions with pros/cons

## Error Handling Strategy

- **Define errors out of existence** — design APIs with no exceptions when possible
- **Mask exceptions** at low levels to protect higher layers
- **Aggregate exceptions** with general-purpose handlers
- **Just crash** for rare, unrecoverable errors

## Comment Standards

- **Self-documenting code first** — improve naming and structure before adding comments
- **WHY over WHAT** — comments explain intent and reasoning, not mechanics
- **Reduce cognitive load** — make implicit knowledge explicit
- **Zero redundancy** — never restate what code already expresses

**DO comment**: design decisions/trade-offs, non-obvious behavior, interface contracts, gotchas/edge cases, cross-module dependencies

**DON'T comment**: self-evident code, well-named variables/functions, standard patterns, implementation details visible in code

When modifying code:
1. **Remove** comments that restate what code does
2. **Keep** comments that explain WHY
3. **Add** comments only for non-obvious behavior or design decisions
4. **Update** stale comments when code changes invalidate them
5. **Never** add comments just to fill space or appear thorough

## Comment Cleanup Procedure

When invoked directly with a file path (`/code-quality <file>`), clean up its comments per the Comment Standards above:

1. **Read the file** to understand its purpose and structure
2. **Suggest naming improvements** that make code self-documenting, applying them if safe
3. **Remove** comments that restate code, add noise, or are outdated
4. **Add** comments only where they explain non-obvious behavior, design decisions, complex algorithms, or essential interface contracts
5. Leave the file cleaner than found
