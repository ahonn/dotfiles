---
name: find-skills
description: Find and evaluate installable agent skills when the user asks to discover skills or extend agent capabilities.
---

# Find Skills

Use this workflow for skill discovery or installation requests. Ordinary requests to fix code, explain a concept, or build a feature do not require a skill search.

## Discover

Check the available skill catalog first to avoid recommending a duplicate. Identify the requested capability and search for that workflow using the available registry or CLI, such as `npx skills find <query>`. Confirm the installed CLI's options before using version-dependent commands.

The [skills directory](https://skills.sh/) can help locate candidates. A leaderboard is optional; popularity alone does not establish fit or quality.

## Evaluate

Read a candidate's skill instructions and relevant scripts before recommending it. Check:

- Whether its trigger matches the requested workflow without attracting unrelated tasks.
- Whether it adds useful domain knowledge or executable resources beyond generic advice.
- Whether its tools, runtime, platforms, and installation layout fit the user's environment.
- Whether its approval rules and side effects preserve the user's scope and existing authorization.
- Whether its sources and maintenance history support the behavior it claims.

Prefer a small set of relevant candidates. Report material limitations and link to the actual source; do not invent install counts or treat star thresholds as a quality guarantee.

## Install and Finish

Install when the user has requested or approved installation; reuse that authorization. Confirm the target location from the request and existing configuration instead of defaulting to global installation.

For Nix-managed skills, locate the maintained source and symlink scheme before writing. Avoid duplicate copies, edits inside the Nix store, or overwriting an existing customized skill. Check the installed result is discoverable and report what was added.

If no suitable skill is found, explain the gap. Continue any already-authorized underlying task with available capabilities; do not require the user to repeat that request. Creating a new skill is a separate option when a recurring workflow justifies it.
