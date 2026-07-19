#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# ==============================================================================
# Variables and Utilities
# ==============================================================================

# Colors for messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect Operating System
OS="$(uname -s)"
case "$OS" in
  Linux*)     MACHINE="Linux" ;;
  Darwin*)    MACHINE="Mac" ;;
  CYGWIN*|MINGW*|MSYS*) MACHINE="Windows" ;;
  *)          MACHINE="UNKNOWN:${OS}" ;;
esac

# Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

# ==============================================================================
# Core Dependencies
# ==============================================================================

install_dependencies() {
  local install_casks="$1"
  info "Checking package manager (Homebrew)..."
  
  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew is not installed. Installing automatically (may prompt for sudo password)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to PATH temporarily so the script can continue
    if [[ "$MACHINE" == "Linux" ]] && [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$MACHINE" == "Mac" ]] && [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  success "Homebrew detected."

  info "Checking Brewfile dependencies..."
  if [ -f "Brewfile" ]; then
    if brew bundle check --file=Brewfile >/dev/null 2>&1; then
      success "All core Brewfile packages are already installed."
    else
      info "Installing missing core packages from Brewfile..."
      brew bundle install --file=Brewfile || warn "Some packages failed to install. Continuing script execution..."
      success "Package installation step finished."
    fi
  else
    warn "Brewfile not found."
  fi

  if [ "$install_casks" == "true" ] && [ -f "Brewfile.cask" ]; then
    info "Installing optional Cask packages from Brewfile.cask..."
    brew bundle install --file=Brewfile.cask || warn "Some Cask packages failed to install. Continuing script execution..."
    success "Cask package installation step finished."
  fi
}

# ==============================================================================
# Installation Functions
# ==============================================================================

update_submodules() {
  info "Updating Git submodules..."
  git submodule update --init --recursive
  success "Submodules updated."
}

clean_invalid_symlinks() {
  info "Checking for invalid legacy symlinks..."
  local abs_dotfiles
  abs_dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Scan standard config and local directories for symlinks (up to depth 4)
  find "$HOME/.local" "$HOME/.config" -maxdepth 4 -type l 2>/dev/null | while read -r symlink; do
    local target
    target="$(readlink "$symlink")"
    
    # We only care about symlinks pointing to this dotfiles repository
    if [[ "$target" == *"dotfiles"* ]]; then
      local symlink_dir abs_target relative_to_dotfiles first_component
      symlink_dir="$(dirname "$symlink")"
      
      # Resolve absolute path portably
      if abs_target="$(cd "$symlink_dir" && cd "$(dirname "$target")" 2>/dev/null && pwd)"; then
        abs_target="$abs_target/$(basename "$target")"
        
        if [[ "$abs_target" == "$abs_dotfiles/"* ]]; then
          relative_to_dotfiles="${abs_target#$abs_dotfiles/}"
          first_component="${relative_to_dotfiles%%/*}"
          
          # If the first directory component starts with a dot (like .local or .config),
          # it means the symlink points directly to the repository root's dot-directories,
          # bypassing the Stow package structure (which should go through packages like 'common').
          if [[ "$first_component" == .* ]]; then
            warn "Removing invalid legacy symlink: $symlink -> $target"
            rm "$symlink"
          fi
        fi
      fi
    fi
  done
}

run_stow_safe() {
  local package="$1"
  local max_retries=5
  local retry=0
  
  while [ $retry -lt $max_retries ]; do
    local exit_code=0
    local stow_err
    stow_err=$(stow -d . -t "$HOME" --restow "$package" 2>&1) || exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
      return 0
    fi
    
    if echo "$stow_err" | grep -q "would cause conflicts"; then
      info "Stow detected conflicts for package '$package'. Resolving..."
      
      local conflicts
      conflicts=$(echo "$stow_err" | grep "over existing target" | sed -E 's/.*over existing target ([^ ]+).*/\1/')
      
      if [ -z "$conflicts" ]; then
        error "Failed to parse Stow conflicts. Error output:"
        echo "$stow_err"
        return $exit_code
      fi
      
      for rel_path in $conflicts; do
        local target_file="$HOME/$rel_path"
        local source_file="./$package/$rel_path"
        
        if [ -e "$target_file" ] || [ -L "$target_file" ]; then
          if [ -f "$target_file" ] && [ -f "$source_file" ] && cmp -s "$target_file" "$source_file"; then
            warn "Removing identical existing file: $target_file"
            rm "$target_file"
          else
            local backup_file="${target_file}.backup"
            warn "Backing up conflicting target: $target_file -> $backup_file"
            mv "$target_file" "$backup_file"
          fi
        fi
      done
      
      retry=$((retry + 1))
    else
      error "Stow failed with error:"
      echo "$stow_err"
      return $exit_code
    fi
  done
  
  error "Failed to resolve Stow conflicts for package '$package' after $max_retries attempts."
  return 1
}

select_environment() {
  local input_env="$1"
  
  # Normalize input arguments
  case "$input_env" in
    --mac|-mac|mac) echo "mac"; return ;;
    --dms|-dms|dms) echo "dms"; return ;;
    --i3|-i3|i3) echo "i3"; return ;;
    --none|-none|none) echo "none"; return ;;
  esac
  
  # If input was empty/unrecognized, check if running in an interactive terminal
  if [ -t 0 ]; then
    echo -e "${BLUE}[INFO]${NC} Interactive setup: please choose your environment configuration" >&2
    if [[ "$MACHINE" == "Mac" ]]; then
      echo -e "  ${YELLOW}1)${NC} macOS Configuration (macos)" >&2
      echo -e "  ${YELLOW}2)${NC} Only Base Configuration (common)" >&2
      local choice
      read -rp "Select option [1-2, default 1]: " choice
      case "$choice" in
        2) echo "none" ;;
        *) echo "mac" ;;
      esac
    else
      echo -e "  ${YELLOW}1)${NC} Wayland - DankMaterialShell (dms)" >&2
      echo -e "  ${YELLOW}2)${NC} X11 - i3 Window Manager (i3)" >&2
      echo -e "  ${YELLOW}3)${NC} Only Base Configuration (common)" >&2
      local choice
      read -rp "Select option [1-3, default 3]: " choice
      case "$choice" in
        1) echo "dms" ;;
        2) echo "i3" ;;
        *) echo "none" ;;
      esac
    fi
  else
    # Non-interactive mode fallback (sensible defaults)
    if [[ "$MACHINE" == "Mac" ]]; then
      echo "mac"
    else
      echo "none"
    fi
  fi
}

symlink_dotfiles() {
  local target_env="$1"
  
  clean_invalid_symlinks
  
  info "Symlinking base package (common)..."
  run_stow_safe common
  
  if [[ "$target_env" == "mac" ]]; then
    info "Symlinking macOS package (macos)..."
    if [ -d "macos" ]; then run_stow_safe macos; fi
  elif [[ "$target_env" == "dms" ]]; then
    info "Symlinking Wayland package (DankMaterialShell)..."
    if [ -d "wayland-dms" ]; then run_stow_safe wayland-dms; fi
  elif [[ "$target_env" == "i3" ]]; then
    info "Symlinking X11 package (i3)..."
    if [ -d "x11-i3" ]; then run_stow_safe x11-i3; fi
  else
    warn "No graphical environment was installed (only base package 'common')."
  fi
  
  success "Dotfiles symlinked successfully."
}

setup_vscodium() {
  local source_dir="$HOME/dotfiles/common/.config/VSCodium/User"
  if [ ! -d "$source_dir" ]; then
    return
  fi

  info "Configuring VS Code / VSCodium..."

  local target_dirs=()
  if [[ "$OSTYPE" == "darwin"* ]]; then
    target_dirs+=(
      "$HOME/Library/Application Support/Code/User"
      "$HOME/Library/Application Support/VSCodium/User"
    )
  else
    target_dirs+=(
      "$HOME/.config/Code/User"
      "$HOME/.config/VSCodium/User"
    )
  fi

  for target in "${target_dirs[@]}"; do
    mkdir -p "$target"
    ln -sf "$source_dir/settings.json" "$target/settings.json"
    ln -sf "$source_dir/keybindings.json" "$target/keybindings.json"
  done

  local cli_cmd=""
  if command -v codium >/dev/null 2>&1; then
    cli_cmd="codium"
  elif command -v code >/dev/null 2>&1; then
    cli_cmd="code"
  fi

  if [ -n "$cli_cmd" ] && [ -f "$source_dir/extensions.txt" ]; then
    info "Installing VS Code / VSCodium extensions via $cli_cmd..."
    while IFS= read -r ext || [ -n "$ext" ]; do
      [[ -z "$ext" || "$ext" =~ ^# ]] && continue
      $cli_cmd --install-extension "$ext" --force >/dev/null 2>&1 || true
    done < "$source_dir/extensions.txt"
    success "VS Code / VSCodium extensions installed."
  fi
}


setup_tpm() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    info "Installing Tmux Plugin Manager (TPM)..."
    mkdir -p "$HOME/.config/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "TPM installed."
  fi
}

# ==============================================================================
# Main Execution
# ==============================================================================

main() {
  local target_env install_casks="false"
  target_env="$(select_environment "$1")"
  
  # Check if --casks flag is provided in any argument
  for arg in "$@"; do
    case "$arg" in
      --casks|-c|--cask) install_casks="true" ;;
    esac
  done

  # In interactive mode, if flag was not explicitly given, prompt the user
  if [ "$install_casks" == "false" ] && [ -t 0 ]; then
    echo -e "${BLUE}[INFO]${NC} Do you want to install optional Cask packages (fonts/GUI apps)? [y/N]: " >&2
    local choice_cask
    read -rp "Select option [y/N, default N]: " choice_cask
    case "$choice_cask" in
      [yY]|[yY][eE][sS]) install_casks="true" ;;
      *) install_casks="false" ;;
    esac
  fi

  info "Starting dotfiles installation on system: $MACHINE (Target: $target_env | Casks: $install_casks)"
  
  install_dependencies "$install_casks"
  update_submodules
  symlink_dotfiles "$target_env"
  setup_vscodium
  setup_tpm
  
  echo ""
  success "Installation completed successfully!"
}

# Execute the script
main "$@"

