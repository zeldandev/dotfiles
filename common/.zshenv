# ~/.zshenv
#
# This file is sourced by Zsh for EVERY invocation (interactive, non-interactive,
# login, and non-login). It is the very first configuration file Zsh loads.
#
# IMPORTANT:
# 1. Do NOT generate any stdout here (no echo, printf, etc.). Printing output in
#    non-interactive shells breaks automated protocols like scp, rsync, and sftp.
# 2. Keep this file extremely minimal and fast. Slow operations (like calling
#    subprocesses or heavy command evaluations) will delay every single Zsh script
#    or background task run on your machine.
# 3. Only set essential environment variables and PATH options here.

# Define custom paths to shell and Zsh configuration directories.
# Note: Zsh natively searches ZDOTDIR for its configuration files (like .zshrc).
# If you ever want to keep your $HOME clean of .zshrc, you can set:
#   export ZDOTDIR=$HOME/.config/shell/zsh
# For now, we define SHELL_DOT_DIR and ZSH_DOT_DIR to align with your setup.
export SHELL_DOT_DIR=$HOME/.config/shell
export ZSH_DOT_DIR=$SHELL_DOT_DIR/zsh

# Load common environment variables (EDITOR, VISUAL, PAGER, HISTSIZE, etc.).
# Sourcing 'envrc' here makes these variables globally available to any script
# or application launched under Zsh, even if it is not an interactive shell.
if [ -f "$SHELL_DOT_DIR/envrc" ]; then
  source "$SHELL_DOT_DIR/envrc"
fi
