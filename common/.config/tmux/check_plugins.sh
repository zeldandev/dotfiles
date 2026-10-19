#!/usr/bin/env bash
# Ensure TPM and every plugin declared with `set -g @plugin` are installed.
# This must run BEFORE `run-shell '~/.local/share/tmux/plugins/tpm/tpm'` so
# that plugins installed on the very first start are also sourced.

set -u

# Keep plugin clones outside of the dotfiles repository.
PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins"
TPM_DIR="$PLUGINS_DIR/tpm"

# Bootstrap TPM when it is missing (e.g. fresh clone or wipe).
if [ ! -x "$TPM_DIR/tpm" ]; then
    mkdir -p "$PLUGINS_DIR"
    # Remove a leftover empty directory so git clone can write into the path.
    if [ -d "$TPM_DIR" ]; then
        if [ -n "$(find "$TPM_DIR" -mindepth 1 -print -quit 2>/dev/null)" ]; then
            echo "tmux: TPM directory exists but is incomplete: $TPM_DIR" >&2
            exit 1
        fi
        rmdir "$TPM_DIR"
    fi
    if ! git clone --single-branch --recursive \
        https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
        echo "tmux: failed to clone TPM (check network access)" >&2
        exit 1
    fi
fi

# tpm only sets this in its own init script; install_plugins needs it too.
if ! tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH >/dev/null 2>&1; then
    tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$PLUGINS_DIR/" 2>/dev/null || true
fi

# Idempotent: only missing plugins are cloned.
"$TPM_DIR/bin/install_plugins"
