#!/usr/bin/env bash

set -e -u -o pipefail

ZELLIJ_CONFIG_PATH="${HOME}/.config/zellij/config.kdl"
ZELLIJ_THEME_LIGHT="dawnfox"
ZELLIJ_THEME_DARK="carbonfox"

if [[ $# -eq 0 ]]; then
  echo "Error: Missing theme argument." >&2
  exit 1
fi

case "$1" in
  light)
    sed -i '' -E "s/^theme .*/theme \"$ZELLIJ_THEME_LIGHT\"/" "$ZELLIJ_CONFIG_PATH"
    ;;
  dark)
    sed -i '' -E "s/^theme .*/theme \"$ZELLIJ_THEME_DARK\"/" "$ZELLIJ_CONFIG_PATH"
    ;;
  *)
    echo "Error: Invalid theme '$1'. Expected 'light' or 'dark'." >&2
    exit 1
    ;;
esac
