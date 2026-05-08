#!/bin/bash
PANE_ID="$1"
STATE_DIR="${TMPDIR:-/tmp}/claude-state"
ICON="🤖"

[ -z "$PANE_ID" ] && exit 0
[ ! -d "$STATE_DIR" ] && exit 0

STATE_ID="${PANE_ID//[^a-zA-Z0-9]/_}"
STATE_FILE="$STATE_DIR/$STATE_ID"

[ ! -f "$STATE_FILE" ] && exit 0

# Verify the pane still exists and runs claude — clean up stale files
if ! tmux display-message -t "$PANE_ID" -p '#{pane_pid}' >/dev/null 2>&1; then
    rm -f "$STATE_FILE"
    exit 0
fi

PANE_PID="$(tmux display-message -t "$PANE_ID" -p '#{pane_pid}' 2>/dev/null)"
if [ -n "$PANE_PID" ] && ! pgrep -P "$PANE_PID" -f "claude" >/dev/null 2>&1; then
    rm -f "$STATE_FILE"
    exit 0
fi

echo " $ICON"
