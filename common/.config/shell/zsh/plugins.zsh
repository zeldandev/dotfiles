# Zsh plugin manager and configuration
export ZSH_PLUGINS_DIR="$ZSH_DOT_DIR/plugins"

function zsh_add_plugin() {
  local repo=$1
  local plugin_name=$(echo $repo | cut -d "/" -f 2)
  local file_path="$ZSH_PLUGINS_DIR/$plugin_name"
  local init_file=""

  # 1. Clone automatically if not exists
  if [ ! -d "$file_path" ]; then
    echo "Cloning Zsh plugin: $plugin_name..."
    mkdir -p "$ZSH_PLUGINS_DIR"
    git clone "https://github.com/$repo.git" "$file_path" --depth 1
  fi

  # 2. Find valid initialization file
  if [ -f "$file_path/$plugin_name.plugin.zsh" ]; then
    init_file="$file_path/$plugin_name.plugin.zsh"
  elif [ -f "$file_path/$plugin_name.zsh" ]; then
    init_file="$file_path/$plugin_name.zsh"
  fi

  if [ -n "$init_file" ]; then
    # 3. Compile to bytecode (.zwc) if not compiled or if source changed
    if [ ! -f "${init_file}.zwc" ] || [ "$init_file" -nt "${init_file}.zwc" ]; then
      zcompile "$init_file"
    fi
    source "$init_file"
  else
    echo "Error loading plugin [$plugin_name]. Config file not found!"
  fi
}

# Function to pull updates for all installed plugins
function zsh_update_plugins() {
  echo "Updating all Zsh plugins..."
  for dir in "$ZSH_PLUGINS_DIR"/*/; do
    if [ -d "$dir/.git" ]; then
      echo "-> Updating $(basename "$dir")..."
      git -C "$dir" pull --ff-only
      # Remove old compiled files to force recompilation on next load
      rm -f "$dir"/*.zwc
    fi
  done
  echo "All plugins updated successfully!"
}

# --- plugins
zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
