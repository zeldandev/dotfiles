### Personal zsh config

# If not running interactively, do not initialize interactive settings.
# (Although .zshrc is only read by interactive shells, this is a safe fallback).
[[ $- != *i* ]] && return

# 1. Load PATH configuration (includes user bin folders, mise, etc.)
[ -f "$SHELL_DOT_DIR/pathrc" ] && source "$SHELL_DOT_DIR/pathrc"

# 2. Load interactive environment variables (EDITOR, VISUAL, history, etc.)
# Loaded after pathrc so that commands like 'nvim' are already in the PATH.
[ -f "$SHELL_DOT_DIR/envrc" ] && source "$SHELL_DOT_DIR/envrc"

# 3. Load command aliases
[ -f "$SHELL_DOT_DIR/aliasrc" ] && source "$SHELL_DOT_DIR/aliasrc"

# 4. Zsh core options
unsetopt BEEP                    # Beeping is annoying
setopt auto_cd                   # Change directories without cd
setopt autocd extendedglob nomatch
setopt interactive_comments
setopt hist_expire_dups_first    # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups         # Dont display duplicates during searches.
setopt hist_ignore_space         # Ignore all commands starting with a blank space
setopt share_history             # Share history between multiple shells
setopt appendhistory             # Append history to the history file

# 5. Load advanced completions configuration
[ -f "$ZSH_DOT_DIR/completions.zsh" ] && source "$ZSH_DOT_DIR/completions.zsh"

# 6. Load Zsh functions and plugins (must be loaded before keybindings so ZLE widgets are defined)
export ZSH_AUTOSUGGEST_USE_ASYNC=true
[ -f "$ZSH_DOT_DIR/plugins.zsh" ] && source "$ZSH_DOT_DIR/plugins.zsh"

# 7. Load keybindings and FZF integration
[ -f "$ZSH_DOT_DIR/keybindings.zsh" ] && source "$ZSH_DOT_DIR/keybindings.zsh"


# 8. Load Prompt (Starship if installed, otherwise fallback to clean prompt)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Simple, elegant fallback prompt
  PROMPT='%F{172}%n%f%F{magenta}@%f%F{green}%m%f%F{cyan}:%1~%f%F{magenta}$%f '
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# Lazy load conda to optimize shell startup speed
conda() {
  unfunction conda
  __conda_setup="$('/home/zeldan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/home/zeldan/anaconda3/etc/profile.d/conda.sh" ]; then
          . "/home/zeldan/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/home/zeldan/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  conda "$@"
}
# <<< conda initialize <<<

# Load machine-specific interactive configurations from an untracked local file if it exists.
# This is ideal for local aliases, functions, or custom interactive shell logic.
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

