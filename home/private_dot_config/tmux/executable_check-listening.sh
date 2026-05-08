#!/bin/bash
# Checks if any process in a tmux pane is listening on a TCP port
# Uses caching with a longer TTL to avoid running lsof on every status refresh
#
# Usage: check-listening.sh <pane_pid>
# Returns: icon if listening, empty otherwise

PANE_PID="$1"
CACHE_SECONDS=10
CACHE_DIR="${TMPDIR:-/tmp}/tmux-listening-cache"
ICON="󰒋"

[ -z "$PANE_PID" ] && exit 0

mkdir -p "$CACHE_DIR"
CACHE_FILE="$CACHE_DIR/$PANE_PID"

if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [ "$cache_age" -lt "$CACHE_SECONDS" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

result=""
if [ -n "$PANE_PID" ]; then
    pids=$(pgrep -d '|' -P "$PANE_PID" 2>/dev/null)
    pids="${PANE_PID}${pids:+|$pids}"
    if lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 {print $2}' | grep -qE "^($pids)$"; then
        result=" $ICON"
    fi
fi

echo -n "$result" > "$CACHE_FILE"
echo -n "$result"
