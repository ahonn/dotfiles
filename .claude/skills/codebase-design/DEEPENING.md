# Deepening a Cluster

Use this guide when callers repeatedly coordinate behavior that could belong to one module. Start with the principles in [SKILL.md](SKILL.md). Consolidation should reduce a demonstrated maintenance cost, not simply combine files.

## Choose boundaries from dependencies

| Dependency | Design considerations |
|------------|-----------------------|
| In-process computation or state | Keep related policy together; retain separate ownership where lifetimes or invariants differ |
| Locally substitutable infrastructure | Reuse a compatible existing stand-in when helpful; account for differences from production |
| Remote services you own | Keep transport details separate from domain decisions when contracts, failures, or verification justify it |
| Third-party services | Isolate vendor details and failure semantics where they would otherwise spread across callers |

A port or injected function can control I/O and support verification, but it is not mandatory for every dependency. Prefer the smallest boundary that provides a concrete benefit. A single production adapter can justify a seam when it isolates vendor or lifecycle coupling; multiple adapters alone do not prove a good abstraction.

Keep internal seams private unless callers need to configure them. Do not expose a test-only dependency as part of the public contract by default.

## Preserve behavioral coverage

Follow the global AGENTS.md test mode. When changing module boundaries, prefer assertions on observable outcomes and keep focused tests for useful internal contracts. Remove obsolete tests only after checking that their distinct behavior and edge cases remain covered or are intentionally removed by the task.

Do not replace all existing unit tests with a larger test merely because the module became deeper. Avoid redundant layers of tests that assert the same mechanics; retain complementary checks when they catch different failures. Respect global authorization rules for large deletions and public contract changes.
