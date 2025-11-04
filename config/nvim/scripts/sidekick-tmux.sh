#!/usr/bin/env bash
# Wrapper script for sidekick to launch tmux without status bar

SESSION_ID="$1"
shift

# Create or attach to tmux session with status bar disabled
tmux new -A -s "$SESSION_ID" \; set-option status off \; send-keys "$*" Enter
