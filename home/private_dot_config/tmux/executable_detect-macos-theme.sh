#!/usr/bin/env bash

# Detects macOS appearance mode (dark or light)
# Returns "dark" or "light"

if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
  echo "dark"
else
  echo "light"
fi
