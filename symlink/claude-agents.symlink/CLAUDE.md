# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) specialized agents when working with code analysis, review, refactoring, security auditing, and software design tasks.

## Core Principles

### Software Design Philosophy

These guidelines focus on minimizing complexity and maximizing long-term maintainability and readability.

**⚠️ IMPORTANT: Code Quality Standards**

- **Prioritize simplicity over cleverness** - code should be easy to understand and modify
- **Apply the "campsite rule"** - leave code cleaner than you found it
- **Focus on reader experience** - code is read more than it's written
- **Eliminate duplication** - ensure everything is stated once and only once

### Complexity Management

```
Complexity = Dependencies + Obscurity
```

**Complexity Symptoms to Watch For**:

- **Change Amplification**: Small changes require modifications in many places
- **Cognitive Load**: Developers need excessive information to complete tasks
- **Unknown Unknowns**: Unclear what code needs modification (worst symptom)

**Mitigation Strategies**:

- Adopt "zero tolerance" for incremental complexity growth
- Invest time upfront in design to accelerate long-term development
- Avoid tactical shortcuts that create technical debt

## Development Guidelines

### Strategic Programming

- **Working code isn't enough** - prioritize great design and system structure
- **Investment mindset** - short-term design investment yields long-term development speed
- **Design it twice** - first idea is rarely best; consider multiple approaches

### Modular Design Principles

- **Deep Modules**: Provide powerful functionality through simple interfaces
- **Information Hiding**: Encapsulate design decisions within implementations
- **General-Purpose Design**: Combat over-specialization to reduce complexity
- **Avoid "Classitis"**: More classes ≠ better design

### Error Handling Strategy

- **Define errors out of existence** - design APIs with no exceptions when possible
- **Mask exceptions** at low levels to protect higher layers
- **Aggregate exceptions** with general-purpose handlers
- **Consider crashing** for rare, difficult-to-handle errors

### Code Quality Standards

**Naming Conventions**:

- Names should create clear mental images
- Be precise, not generic or vague
- Maintain consistency throughout the system
- Avoid unnecessary words

**Comment Guidelines**:

- Essential for abstraction - capture design information not in code
- Describe **what** (interface) vs **how** (implementation)
- Avoid redundant comments that restate obvious code
- Use as design tool during development

**Consistency Requirements**:

- Reduce complexity through uniform patterns
- Create cognitive leverage for developers
- "When in Rome, do as the Romans do"
- Use automated checkers and code reviews

## Refactoring Standards

### Core Methodology

Refactoring is a disciplined technique for improving existing code design while preserving behavior.

**Refactoring Rhythm**:

```bash
# Always follow this pattern:
1. Take small, behavior-preserving steps
2. Ensure code stays compilable and tests pass
3. If tests fail, revert and take smaller steps
4. Compose substantial changes from tiny steps
```

### Refactoring Benefits

- **Improves Software Design**: Prevents architectural decay over time
- **Enhances Understanding**: Clearer code reduces cognitive load
- **Reveals Bugs**: Deep code understanding helps spot issues
- **Accelerates Development**: Good design enables faster feature development

### Supporting Practices

- **Self-Testing Code**: Frequent test runs with clear pass/fail feedback
- **YAGNI Principle**: Add flexibility only when genuinely needed
- **Performance Optimization**: Always measure first, optimize specific bottlenecks

### Continuous Improvement

- **Opportunistic Refactoring**: Improve code during feature development
- **Campsite Rule**: Leave frequently-visited code areas cleaner
- **Kent Beck's Advice**: _"Make the change easy (warning: may be hard), then make the easy change"_

## Agent-Specific Guidelines

### Code Review Focus Areas

- Architecture and design patterns adherence
- Complexity reduction opportunities
- Consistency with existing codebase patterns
- Performance considerations (measure before optimizing)

### Refactoring Priorities

- Eliminate duplication and special cases
- Improve module depth (simple interfaces, rich functionality)
- Reduce dependencies and information leakage
- Enhance code obviousness and readability

### Security Audit Standards

- Focus on defensive security measures only
- Identify vulnerabilities with actionable remediation steps
- Review authentication, input validation, and data protection
- Analyze dependencies and infrastructure configurations

### Software Design Analysis

- Apply complexity reduction principles
- Identify design issues causing change amplification
- Suggest architectural improvements based on deep module principles
- Focus on strategic vs tactical programming approaches

## Code Analysis Workflow

### Initial Assessment

1. **Understand the context** - read surrounding code and documentation
2. **Identify patterns** - follow existing conventions and frameworks
3. **Assess complexity** - look for symptoms of poor design
4. **Evaluate testability** - ensure changes can be verified

### Implementation Standards

1. **Follow existing patterns** - mimic code style and architectural decisions
2. **Verify libraries/frameworks** - check what's already in use (package.json, etc.)
3. **Security best practices** - never introduce secrets or vulnerabilities
4. **Test-driven approach** - ensure changes are verifiable

### Quality Gates

- All changes must maintain or improve code quality
- No introduction of complexity symptoms
- Consistent with established patterns
- Self-documenting through good names and structure
