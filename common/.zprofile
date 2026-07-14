# ~/.zprofile
#
# This file is sourced by Zsh ONLY for login shells (e.g., when logging in via
# SSH, console TTY, or starting a terminal window on macOS). It is loaded
# after .zshenv but before .zshrc.
#
# Since Zsh is not a strict POSIX shell, it does not load ~/.profile by default.
# Placing the initialization code here ensures a consistent environment.

# 1. Source the generic POSIX-compliant .profile.
# This ensures that any standard environmental variables configured for your Linux
# GUI session (or other standard POSIX logins) are inherited by Zsh.
if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

# 2. Initialize Homebrew (eval "brew shellenv").
# Why here? Homebrew recommends evaluating 'brew shellenv' to setup PATH, MANPATH, etc.
# However, running $(brew shellenv) executes a subprocess which can add 20-50ms or more
# to your terminal startup time. Placing this in .zprofile ensures it runs only once
# per login session (Linux) or terminal window (macOS), keeping your interactive Zsh
# subshells starting up instantly.
if [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS (Apple Silicon default path)
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  # macOS (Intel default path / custom homebrew folder)
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
elif [[ "$(uname -s)" == "Linux" ]]; then
  # Linuxbrew default installation path
  if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Load machine-specific login configurations from an untracked local file if it exists.
if [ -f "$HOME/.zprofile.local" ]; then
  source "$HOME/.zprofile.local"
fi
