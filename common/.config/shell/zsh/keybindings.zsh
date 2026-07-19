# Keybindings and FZF integration

# Disable Ctrl+S terminal freeze (makes terminal flow better)
stty stop undef
zle_highlight=('paste:none')

# Enable vi-mode keybindings (optional, but standard for power users)
bindkey -v

# Dynamic Vi-mode cursor shape (beam cursor '|' in insert mode, block '█' in normal mode)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[2q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[5q'
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5q'
}
zle -N zle-line-init

# Accept Zsh autosuggestions with Ctrl+Y
bindkey '^Y' autosuggest-accept

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
