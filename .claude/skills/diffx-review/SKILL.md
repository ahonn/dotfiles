---
name: diffx-review
description: "Run a diffx code review session. Use 'start' to launch the browser UI for inline comments, then 'finish' to apply them. Use when the user invokes /diffx-review."
user_invocable: true
---

# diffx Review

Two-step diffx review workflow controlled by an explicit subcommand the user types after `/diffx-review`:

| Invocation | Action |
|---|---|
| `/diffx-review start [diffx-args...]` | Launch the diffx server in the background and open the browser UI |
| `/diffx-review finish` | Fetch open comments from the running diffx server, apply each one, mark resolved |
| `/diffx-review` (no subcommand) | Default to `start` with auto-detected diff target (see below) |

## start

Run diffx via `npx` (no global install needed). Use the Bash tool with `run_in_background: true` so the server stays alive while the user reviews in the browser.

**Always prefix the command with `GIT_CONFIG_GLOBAL=/dev/null`.** This user has `diff.external = difftastic` in their global git config, which makes `git diff` emit difftastic's structural format instead of unified diff. diffx's frontend can't parse that and shows a blank page. Setting `GIT_CONFIG_GLOBAL=/dev/null` tells the diffx child process to skip the global git config, restoring standard unified diff output. It does NOT affect your interactive shell or the user's git config.

```bash
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli
```

### Auto-detect diff target when no args given

If the user invoked `/diffx-review` (or `/diffx-review start`) **without** any extra arguments, decide the diff target before launching:

1. Check for uncommitted changes: `git status --porcelain`
2. **Has uncommitted changes** → default behavior, review the working tree:
   ```bash
   GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli
   ```
3. **Clean working tree** → diff the current branch against the main branch. Detect the main branch first, then launch:
   ```bash
   # Detect main branch (prefer remote HEAD, fall back to main/master)
   MAIN=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
   MAIN=${MAIN:-$(git show-ref --verify --quiet refs/heads/main && echo main || echo master)}
   GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli -- "$MAIN..HEAD"
   ```
   If the current branch IS the main branch and the tree is clean, there is nothing to review — tell the user and stop.

If the user passed any arguments after `start`, forward them to the diffx CLI verbatim and skip the auto-detection. diffx accepts its own flags (e.g. `-p 8080`, `--no-open`) and a `--` separator after which everything is forwarded to `git diff`.

Common shapes (remember the `GIT_CONFIG_GLOBAL=/dev/null` prefix on every one):

```bash
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli                       # Working tree (default)
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli -- --staged           # Only staged changes
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli -- HEAD~3             # Last 3 commits
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli -- main..HEAD         # Current branch vs main
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli -p 8080               # Custom port (default: random available port)
GIT_CONFIG_GLOBAL=/dev/null npx -y diffx-cli --no-open             # Don't auto-open browser
```

After launching, read the server log to find the actual port (e.g. `diffx server running at http://127.0.0.1:54321`) and tell the user briefly:

> diffx is running at http://127.0.0.1:<port>. Leave inline comments in the browser, then run `/diffx-review finish` to apply them.

Stop here. Do **not** continue to `finish` in the same response — the user has to actually go review first.

## finish

The diffx server from `start` should still be running. Use the port reported earlier in the conversation.

### 1. Fetch comments

```bash
curl -s http://127.0.0.1:<port>/api/comments
```

Response shape:

```json
[
  {
    "id": "uuid",
    "filePath": "src/utils/parser.ts",
    "side": "additions",
    "lineNumber": 42,
    "lineContent": "const x = tokenize(input)",
    "body": "Rename x to parsedToken for clarity",
    "status": "open",
    "createdAt": 1234567890
  }
]
```

### 2. Process each comment with `"status": "open"`

1. Read the file at `filePath`
2. Locate the code using `lineContent` as the anchor (line numbers may have drifted since the comment was written)
3. Apply the change described in `body`
4. Mark the comment resolved:

```bash
curl -s -X PUT http://127.0.0.1:<port>/api/comments/<id> \
  -H "Content-Type: application/json" \
  -d '{"status": "resolved"}'
```

The `side` field tells you whether the anchor lives on an added line (`additions`) or a removed line (`deletions`).

### 3. Edge cases

- Ambiguous comment → ask the user, don't guess.
- Interacting comments (e.g. a rename that touches several places) → handle them together.
- No open comments → tell the user there's nothing to apply.
- `curl: connection refused` → diffx was killed; ask the user to re-run `/diffx-review start` to relaunch it.

### 4. Summary

Briefly report what you applied and how many comments were resolved.
