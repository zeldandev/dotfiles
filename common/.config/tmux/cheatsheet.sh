#!/usr/bin/env bash

# Render the shared cheatsheet in a tmux popup. glow provides the best
# Markdown rendering; bat/less remain useful fallbacks on minimal systems.
set -u

CHEATSHEET="${HOME}/dotfiles/cheatsheet.md"

if command -v glow >/dev/null 2>&1; then
  exec glow -p "$CHEATSHEET"
fi

if command -v bat >/dev/null 2>&1; then
  exec bat --paging=always --style=plain --theme=ansi "$CHEATSHEET"
fi

if command -v batcat >/dev/null 2>&1; then
  exec batcat --paging=always --style=plain --theme=ansi "$CHEATSHEET"
fi

exec less -R "$CHEATSHEET"
