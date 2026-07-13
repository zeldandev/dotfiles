# Keybindings and FZF integration

# Disable Ctrl+S terminal freeze (makes terminal flow better)
stty stop undef
zle_highlight=('paste:none')

# Enable vi-mode keybindings (optional, but standard for power users)
bindkey -v

# Navigate the Zsh completion menu with Ctrl+H/J/K/L
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^l' forward-char

# Initialize FZF shell integration (requires fzf version 0.48+)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Toggle 'sudo' prefix on current command line with Alt+S (or Esc then S)
toggle-sudo() {
  [[ -z $BUFFER ]] && zle up-history
  if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
  else
    LBUFFER="sudo $LBUFFER"
  fi
}
zle -N toggle-sudo
bindkey '\es' toggle-sudo
