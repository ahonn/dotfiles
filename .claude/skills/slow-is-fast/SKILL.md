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

**Auto-reclassification**: if Phase 1 reveals an external contract surface (third-party API, undocumented system behavior, shared type exported to callers, schema/migration), bump up one tier and note why.

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

## Scope Mode

Name the mode at the start of Plan phase. The mode shapes how aggressively to expand or constrain options.

| Mode | When | Posture |
|------|------|---------|
| **expand** | New feature, blank slate | Push scope up. Ask what would make this 10x better. |
| **shape** | Adding to existing code | Hold the baseline, surface expansion options one at a time. |
| **hold** | Bug fix, tight constraints | Scope is locked. Make it correct. |
| **cut** | Plan that grew too large | Strip to the minimum that solves the real problem. |

## Phase 2: Plan Mode (Analysis / Alignment)

1. Briefly restate: objective, key constraints, current state, and the **Scope Mode** for this task
2. Analyze top-down, find root causes, not just patch symptoms
3. Provide **2–3 feasible options**, each including:
   - Summary approach
   - Impact scope (modules/interfaces involved)
   - Pros and cons
   - Potential risks
   - Verification methods

   **Always include one minimal option and one architecturally complete option.** A homogeneous list of three near-identical plans is not a plan set.

4. **Self-attack the recommendation.** Before presenting, ask what would make the chosen option fail. If the attack holds, present the deformed version. If the attack shatters it, discard and pick again — and tell the user why.
5. **Mark hard-to-undo decisions.** Slow down on those; spend more analysis on anything that cannot be cheaply reversed.
6. **State explicit non-goals.** Name what is being deliberately not built, so scope can stay honest later.
7. Only ask clarifying questions when missing info would block progress
8. Avoid providing essentially identical plans

### No Placeholders in Approved Plans

Before the user approves, every step must be concrete. **Forbidden patterns**: `TBD`, `TODO`, "implement later", "similar to step N", "details to be determined", "as needed". A plan with placeholders is not a plan — it is a promise to plan later.

If a section cannot be evaluated from available information, say so explicitly: "Cannot assess X without seeing Y." Do not guess to fill the gap.

### Exit Gate: Confidence Check

Before handing off to Code mode, score confidence on three axes:

1. **Problem understood?** State in one sentence what the user actually needs and why.
2. **Approach is the simplest that works?** Is there a cheaper path I have not considered?
3. **Unknowns resolved or explicitly deferred?** No hidden `TBD`.

If any axis is low: **loop back**.
- Low on (1) → return to Phase 1 (more research)
- Low on (2) → re-enter Phase 2 with the cheaper alternative explicitly evaluated
- Low on (3) → name each unresolved unknown; resolve it or mark it as an explicit deferral

If all three are solid AND (user explicitly chose an option OR one option is clearly superior): state the confidence assessment in 2–3 sentences, then enter Code mode directly.

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
