# Zsh completion configuration

# Cache completion definitions for faster shell startup
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

# Initialize completion system
autoload -Uz compinit
_comp_options+=(globdots) # Include hidden files in autocompletion

# Cache compinit: compile zcompdump once a day
# (N.mh+24) uses Zsh glob qualifiers: N (null_glob), mh+24 (modified more than 24 hours ago)
# We store the match in an array to avoid spawning a 'find' subprocess.
local -a old_dump=( $HOME/.zcompdump(N.mh+24) )
if [[ ! -f "$HOME/.zcompdump" ]] || (( $#old_dump > 0 )); then
  compinit
else
  compinit -C
fi

# Enable complist module for arrow-key navigation in completion menu
zmodload zsh/complist
zstyle ':completion:*' menu select

# Case-insensitive, substring, and partial completion matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Colorize completion lists using system LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group results by type and format descriptions nicely
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}message -> %d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%f %d'

# Format directory listings in completion
zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Offer indexes for man page completion
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
