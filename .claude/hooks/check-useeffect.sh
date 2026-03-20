#!/usr/bin/env bash
# PostToolUse hook: detect direct useEffect() in React files
# Returns JSON with additionalContext when violation found

f=$(jq -r '.tool_input.file_path' 2>/dev/null)
[ -z "$f" ] && exit 0
[ ! -f "$f" ] && exit 0

# Only check React files
echo "$f" | grep -qE '\.(tsx?|jsx?)$' || exit 0

# Check for direct useEffect( calls, excluding useMountEffect and eslint-disable comments
if grep 'useEffect(' "$f" 2>/dev/null | grep -v 'useMountEffect' | grep -v 'eslint-disable' | grep -q 'useEffect('; then
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"VIOLATION: Direct useEffect() detected in %s. You MUST invoke the no-useeffect skill and refactor to eliminate all direct useEffect calls. Use derived state, event handlers, data-fetching libraries, useMountEffect, or key-based remounting."}}' "$f"
fi
