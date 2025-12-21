#!/bin/bash
# Checks if any process in a tmux pane is listening on a TCP port
# Uses caching to avoid running lsof too frequently
#
# Usage: check-listening.sh <pane_pid> [cache_seconds]
# Returns: icon if listening, empty otherwise

PANE_PID="$1"
CACHE_SECONDS="${2:-3}"  # Cache for 3 seconds by default
CACHE_DIR="${TMPDIR:-/tmp}/tmux-listening-cache"
ICON="󰒋"  # Nerd font server icon

[ -z "$PANE_PID" ] && exit 0

mkdir -p "$CACHE_DIR"
CACHE_FILE="$CACHE_DIR/$PANE_PID"

# Check cache freshness
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [ "$cache_age" -lt "$CACHE_SECONDS" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Get all descendant PIDs recursively
get_descendants() {
    local pid=$1
    echo "$pid"
    for child in $(pgrep -P "$pid" 2>/dev/null); do
        get_descendants "$child"
    done
}

pids=$(get_descendants "$PANE_PID" | paste -sd '|' -)

# Check if any descendant is listening on TCP
result=""
if [ -n "$pids" ]; then
    if lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 {print $2}' | grep -qE "^($pids)$"; then
        result=" $ICON"
    fi
fi

# Cache the result
echo -n "$result" > "$CACHE_FILE"
echo -n "$result"
