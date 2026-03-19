---
name: slow-is-fast
description: "Research → Plan → Code workflow. Enforces evidence-based reasoning, codebase research, and structured planning before code modifications. Applied automatically for moderate+ tasks."
user-invocable: false
---

# Development Workflow: Slow is Fast

**Core rule**: Never modify code based on assumptions alone. Ground every decision in evidence.

## Complexity Assessment

| Complexity | Characteristics | Workflow |
|---|---|---|
| **Trivial** | Typo, formatting, <10 lines, single API | Answer directly, quick grep for context |
| **Moderate** | Non-trivial logic in single file, local refactoring | Standard: all phases below |
| **Complex** | Cross-module design, concurrency, new architecture | Deep: use Explore agent, WebSearch, context7 |

### Skip Conditions

Research can be minimal when:
- Pure formatting, typo, or rename fixes
- User explicitly provides the exact solution or says "just do it"
- Follow-up changes in same conversation where research was already done
- The change is within code you just wrote in this conversation

## Phase 0: Reasoning Principles

Before any action, apply these internally (do not output unless requested).

### Constraint Priority

Analyze in this order:
1. **Rules and Constraints** — never violate for convenience
2. **Operation Order and Reversibility** — ensure no step blocks subsequent steps
3. **Prerequisites and Missing Information** — only ask when missing info significantly affects solution choice
4. **User Preferences** — style, language (without violating higher priorities)

### Risk Assessment

- **Low-risk** (searches, simple refactoring): Proceed with existing information
- **High-risk** (data modifications, API changes, history rewrites): State risks, provide safer alternatives

### Abductive Reasoning

When encountering problems:
- Don't just treat symptoms — infer deeper causes
- Construct 1–3 hypotheses ordered by likelihood
- Verify most likely first; update when invalidated

### Conflict Resolution Priority

1. Readability and Maintainability
2. Correctness and Safety
3. Explicit business requirements
4. Performance and resource usage
5. Code length and local elegance

## Phase 1: Research

Execute **before** entering Plan mode. Summarize findings before proposing any approach.

For moderate+ tasks, **use Explore agent** to run research in an isolated context.

### 1.1 Codebase Search

Understand what already exists. Do not reinvent or contradict existing patterns.

- **Grep** for related function names, types, patterns, error messages
- **Glob** for related files by naming convention
- **Read** key files to understand existing architecture and conventions
- For broad exploration, use **Explore agent** to parallelize searches

### 1.2 Documentation Lookup

Verify API behavior, library usage, and framework conventions against official sources.

- Use **context7** (`resolve-library-id` → `query-docs`) for libraries/frameworks involved
- Use **WebSearch** when context7 lacks coverage or for newer APIs
- Check changelogs/migration guides if version-specific behavior is involved

### 1.3 Solution Survey & Reuse Decision

Apply the **reuse decision matrix** (see `references/research-patterns.md`).

- Search for common pitfalls, edge cases, and known issues
- Identify trade-offs between candidate approaches
- Produce 1-3 candidate approaches with evidence-backed pros/cons

## Phase 2: Plan Mode (Analysis / Alignment)

1. Briefly restate: objective, key constraints, current state
2. Analyze top-down, find root causes, not just patch symptoms
3. Provide **1–3 feasible options**, each including:
   - Summary approach
   - Impact scope (modules/interfaces involved)
   - Pros and cons
   - Potential risks
   - Verification methods
4. Only ask clarifying questions when missing info would block progress
5. Avoid providing essentially identical plans

### Exit Conditions

- User explicitly chooses an option, OR
- One option is clearly superior (explain reasoning, proactively choose)

Once conditions met → enter Code mode directly.

## Phase 3: Code Mode (Execute Plan)

1. Before providing code, briefly state which files/modules will be modified and why
2. Prefer **minimal, reviewable changes**: local snippets/patches over complete files
3. Indicate how to verify: tests/commands to run, new test cases if needed
4. If major problems discovered → pause, switch back to Plan mode

### Output Should Include

- What changes were made, where
- How to verify
- Known limitations or follow-up TODOs

## Anti-Patterns

- **Cargo-cult coding**: Copying patterns without understanding why they exist
- **Stale knowledge**: Using remembered API behavior instead of checking current docs
- **Premature implementation**: Jumping to code after reading only one file
- **Research theater**: Searching but ignoring findings that contradict your initial idea
- **Dependency bloat**: Adding a library when a 5-line solution exists in the project
- **NIH syndrome**: Rewriting what already exists because you didn't search thoroughly
- **Symptom patching**: Fixing symptoms without investigating root causes
- **Hasty conclusions**: Providing answers before completing reasoning

See also: `references/research-patterns.md` for anti-rationalization table and reuse decision matrix.
