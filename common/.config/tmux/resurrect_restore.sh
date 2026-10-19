#!/usr/bin/env bash
# Wrapper for tmux-continuum's automatic restore.
# tmux-resurrect prints "Tmux resurrect file not found!" when there is no
# snapshot yet, which happens on a fresh install. Instead of that message we
# take an initial snapshot, so the next start has something to restore.

set -u

PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins"
RESURRECT_SCRIPTS="$PLUGINS_DIR/tmux-resurrect/scripts"

# Same default directory logic as tmux-resurrect (scripts/helpers.sh).
if [ -d "$HOME/.tmux/resurrect" ]; then
    RESURRECT_DIR="$HOME/.tmux/resurrect"
else
    RESURRECT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
fi

if [ -f "$RESURRECT_DIR/last" ]; then
    exec "$RESURRECT_SCRIPTS/restore.sh"
fi

# No saved state yet: create one instead of trying (and failing) to restore.
exec "$RESURRECT_SCRIPTS/save.sh" quiet
