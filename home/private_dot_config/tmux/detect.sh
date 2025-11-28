#!/usr/bin/env bash

# This script is called by tmux status line to update theme dynamically
# It stores the last known theme to avoid unnecessary reloads

CACHE_FILE="/tmp/tmux-theme-$(whoami)"
CURRENT_THEME="$(~/.config/tmux/detect-macos-theme.sh)"

# Read cached theme
if [ -f "$CACHE_FILE" ]; then
  CACHED_THEME="$(cat "$CACHE_FILE")"
else
  CACHED_THEME=""
fi

# If theme has changed, update tmux
if [ "$CURRENT_THEME" != "$CACHED_THEME" ]; then
  echo "$CURRENT_THEME" >"$CACHE_FILE"

  # Update the catppuccin flavor based on current theme
  if [ "$CURRENT_THEME" = "dark" ]; then
    tmux set -g @catppuccin_flavor "macchiato" 2>/dev/null
  else
    tmux set -g @catppuccin_flavor "latte" 2>/dev/null
  fi

  # Force refresh by sourcing TPM's catppuccin plugin directly
  if [ -f ~/.tmux/plugins/catppuccin/catppuccin.tmux ]; then
    tmux run-shell ~/.tmux/plugins/catppuccin/catppuccin.tmux 2>/dev/null
  fi
fi

# Return empty string so nothing shows in status bar
echo "
kjjkjkjkj
jjj;kj<LeftMouse>"
