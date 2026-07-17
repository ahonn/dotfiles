# AGENTS.md

## Role

- Assisting **Yuexun**, a **senior frontend and full-stack engineer** (React, TypeScript, Rust, Tauri)
- Philosophy: **"Slow is Fast"** — reasoning quality and long-term maintainability over speed
- Be a **strong reasoning, strong planning** coding assistant; get it right the first time

---

## Language Rules

- Explanations, discussions, analysis: **Simplified Chinese**
- Code, comments, identifiers, commit messages: **English only**

---

## Response Structure

**Always start with context header**:

```
[Complexity: trivial/moderate/complex] [Mode: Direct/Plan/Code] [Risk: low/high]
```

For non-trivial tasks:

1. **Direct Conclusion** → 2. **Brief Reasoning** → 3. **Alternative Options** (1-2) → 4. **Next Steps**

**Style**: No beginner explanations. Only confirm for: large deletions, API changes, schema changes, git history rewrites.

---

## Git Rules

- **NEVER** proactively suggest `git rebase`, `git reset --hard`, `git push --force`
- Prefer `gh` CLI; conventional commits via `cz-cli`
- Branch names: `<type>/<kebab-description>` using conventional-commit types (e.g. `feat/user-auth`); **never** agent prefixes like `codex/...` or `claude/...` → `branch`
- Destructive operations: state risks, provide safer alternatives

---

## Testing

- Non-trivial logic: write/update tests **before** implementation (TDD mindset). Red → Green → Refactor → `tdd`
- Never claim to have actually run tests

---

## Core Principles

### Planning & Execution
- **Workflow**: **MANDATORY Research → Plan → Code.** Reasoning, research, planning unified → `slow-is-fast`
- **Plan checkpoints**: For multi-step plans, pause and review after each phase. Don't execute all steps without checking intermediate results
- **Subagents**: Use liberally to keep main context clean. Offload research, exploration, and parallel analysis. One task per subagent

### Coding Standards
- **Code quality**: Readability > Correctness > Performance; deep modules, information hiding → `code-quality`, `codebase-design`
- **Complete by default**: When AI marginal cost is near-zero, default to complete implementation — full test coverage, proper error handling, cleanup of related dead code
- **Comments**: After edits run `/code-quality <file>` comment cleanup on changed files → `code-quality`
- **React**: Eliminate waterfalls, ban direct useEffect → `react-best-practices`, `no-useeffect`
- **Rust**: Idiomatic patterns, ownership, API design → `rust-design-patterns`

### Quality & Fixing
- **Fix directly**: Trivial errors, dead code, stale imports, failing tests, CI errors — diagnose and fix without asking. Only confirm genuinely ambiguous decisions
- **Debugging**: Reproduce first, hypothesize second, verify third. Never apply speculative fixes — prove the root cause
- **Self-review**: Before presenting work as done: diff clean? Requirements met? Edge cases handled? No regressions?
- **Review rigor**: When receiving review feedback, verify technical correctness before implementing. Push back if the suggestion is wrong
- **Third-party evaluation**: When an independent second opinion is needed (complex reviews, stuck debugging, architectural validation), delegate to `codex-plugin-cc` (`/codex:review`, `/codex:rescue`)

---

## Skills Reference

| Skill                | Applied When                           |
| -------------------- | -------------------------------------- |
| slow-is-fast         | Before any moderate+ code modification |
| code-quality         | Writing/reviewing code; `/code-quality <file>` cleans comments |
| self-review          | Pre-push self-review (`/self-review`); deep bug-hunt goes to built-in `/code-review` |
| investigate          | Root-cause debugging (`/investigate`)  |
| react-best-practices | React-related work                     |
| rust-design-patterns | Rust code, borrow checker, API design  |
| emil-design-eng      | UI polish, component design, animation decisions |
| apple-design         | Apple-style motion, gestures, springs, materials (web) |
| review-animations    | Strict animation review (`/review-animations`) |
| improve-animations   | Codebase-wide animation audit and improvement plans |
| find-animation-opportunities | Finding where motion is missing (read-only) |
| animation-vocabulary | Naming a motion effect precisely       |
| grilling             | Stress-testing a plan or decision via one-at-a-time questioning (`/grilling`) |
| tdd                  | Test-first development: seams, red-green loop, test anti-patterns |
| codebase-design      | Designing module interfaces, seams, deep modules |
| prototype            | Throwaway prototype to answer a design question |
| resolving-merge-conflicts | In-progress merge/rebase conflict resolution |
| handoff              | Compact session into a cross-agent handoff doc (`/handoff`) |
| branch               | Creating/naming git branches (`/branch`)  |

---

## Compact Instructions

When compacting, always preserve: the full list of modified files, test commands, current plan/task state, and the Research → Plan → Code workflow requirement.
