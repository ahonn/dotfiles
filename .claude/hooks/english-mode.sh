#!/usr/bin/env bash
# UserPromptSubmit hook: enforce English-only input with grammar feedback
# Reads english-mode flag from $PROJECT/.claude/features.json
# Requires: jq

if ! command -v jq &>/dev/null; then
  exit 0
fi

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

[ -z "$CWD" ] || [ -z "$PROMPT" ] && exit 0

# Check project-level feature flag
FEATURES_FILE="$CWD/.claude/features.json"
if [ ! -f "$FEATURES_FILE" ]; then
  exit 0
fi

ENABLED=$(jq -r '.["english-mode"] // false' "$FEATURES_FILE" 2>/dev/null)
[ "$ENABLED" != "true" ] && exit 0

# Skip: slash commands, very short input (< 5 chars), or code-only input
echo "$PROMPT" | grep -qE '^\s*/' && exit 0
[ ${#PROMPT} -lt 5 ] && exit 0

# Detect CJK characters (Chinese/Japanese/Korean)
# Strip content inside code blocks (``` ... ```) before checking
# Use perl for portable Unicode property matching (macOS BSD grep lacks -P)
STRIPPED=$(echo "$PROMPT" | sed '/^```/,/^```/d')
CJK_COUNT=$(echo "$STRIPPED" | perl -CS -ne '$n += () = /[\p{Han}\p{Katakana}\p{Hiragana}\p{Hangul}]/g; END { print $n // 0 }')
TOTAL_COUNT=${#STRIPPED}

# Block if CJK characters exceed 10% of total
if [ "$TOTAL_COUNT" -gt 0 ] && [ "$CJK_COUNT" -gt 0 ]; then
  RATIO=$((CJK_COUNT * 100 / TOTAL_COUNT))
  if [ "$RATIO" -gt 10 ]; then
    jq -n '{
      "decision": "block",
      "reason": "English mode is active. Please rewrite your message in English.\n(Tip: Try expressing what you want — even imperfect English is fine!)"
    }'
    exit 0
  fi
fi

# English input — inject grammar feedback request as additionalContext
jq -n '{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "ENGLISH MODE ON (SWE interview prep). RESPOND IN ENGLISH (override language setting). Append \"**English Tips**\" after your response. Format: \"original\" → \"correction\" (reason). Three categories — omit if clean:\\n1. **Grammar**: spelling, grammar, awkward phrasing\\n2. **Tech Vocabulary**: imprecise terms → precise SWE terminology\\n3. **Interview Phrasing**: casual → professional articulation\\nAll perfect → \"Your English looks great!\" Be specific, encouraging, concise."
  }
}'
