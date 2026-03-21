---
name: english-mode
description: "Toggle English-only mode. Forces English input and provides grammar feedback. Use when: '/english', 'english mode', 'toggle english'."
disable-model-invocation: true
allowed-tools: Bash, Read
argument-hint: "[on|off]"
---

# English Mode Toggle

Toggle English-only mode for the current project. When enabled:
- Non-English input is **blocked** — you must rewrite in English
- Grammar and usage feedback appears at the end of each response

## Check current state

!`jq -r '.["english-mode"] // false' "$CLAUDE_PROJECT_DIR/.claude/features.json" 2>/dev/null || echo "false"`

## Instructions

Based on "$ARGUMENTS" and the current state above:
- If argument is "on" → enable
- If argument is "off" → disable
- If no argument → toggle (flip current state)

To **enable**: ensure `$CLAUDE_PROJECT_DIR/.claude/features.json` exists and has `"english-mode": true`. Use `jq` to merge the key without overwriting other keys. Create the file if it doesn't exist.

To **disable**: set `"english-mode": false` in the same file. If the file has no other truthy keys, you may delete it.

After toggling, report the new state concisely:
- Enabled: "English mode **on** for this project. All input must be in English. Grammar feedback will appear at the end of responses."
- Disabled: "English mode **off** for this project."
