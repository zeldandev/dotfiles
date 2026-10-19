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

# Detect Operating System and WSL Environment
OS="$(uname -s)"
case "$OS" in
  Linux*)     MACHINE="Linux" ;;
  Darwin*)    MACHINE="Mac" ;;
  CYGWIN*|MINGW*|MSYS*) MACHINE="Windows" ;;
  *)          MACHINE="UNKNOWN:${OS}" ;;
esac

IS_WSL=false
if [[ "$MACHINE" == "Linux" ]]; then
  if [[ -n "$WSL_DISTRO_NAME" ]] || [[ -n "$WSL_INTEROP" ]] || grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
    IS_WSL=true
  fi
fi

# Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

# ==============================================================================
# Package Managers & Dependencies
# ==============================================================================

ensure_brew_env() {
  if ! command -v brew >/dev/null 2>&1; then
    if [[ "$MACHINE" == "Linux" ]] && [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$MACHINE" == "Linux" ]] && [ -x "$HOME/.linuxbrew/bin/brew" ]; then
      eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    elif [[ "$MACHINE" == "Mac" ]] && [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ "$MACHINE" == "Mac" ]] && [ -x "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
}

install_homebrew() {
  info "Checking Homebrew installation..."
  ensure_brew_env

  if command -v brew >/dev/null 2>&1; then
    success "Homebrew is already installed."
    return 0
  fi

  warn "Installing Homebrew..."
  local can_use_default_linuxbrew=false
  if [[ "$MACHINE" == "Linux" ]]; then
    if [ -w "/home" ] || [ -w "/home/linuxbrew" ]; then
      can_use_default_linuxbrew=true
    elif command -v sudo >/dev/null 2>&1; then
      if sudo -n true 2>/dev/null; then
        can_use_default_linuxbrew=true
      elif [ -t 0 ] && sudo -v 2>/dev/null; then
        can_use_default_linuxbrew=true
      fi
    fi
  fi

  if [[ "$MACHINE" == "Linux" ]] && [ "$can_use_default_linuxbrew" == "false" ]; then
    info "Insufficient permissions for /home/linuxbrew. Installing Homebrew locally to $HOME/.linuxbrew..."
    if [ ! -d "$HOME/.linuxbrew/Homebrew" ]; then
      git clone https://github.com/Homebrew/brew "$HOME/.linuxbrew/Homebrew"
    fi
    mkdir -p "$HOME/.linuxbrew/bin"
    ln -sf "$HOME/.linuxbrew/Homebrew/bin/brew" "$HOME/.linuxbrew/bin/brew"
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh" 2>/dev/null || true
  else
    local install_success=false
    if [ -t 0 ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && install_success=true || true
    else
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && install_success=true || true
    fi

    if [ "$install_success" = false ]; then
      if [[ "$MACHINE" == "Linux" ]]; then
        warn "Standard Homebrew installation failed. Falling back to local installation in $HOME/.linuxbrew..."
        if [ ! -d "$HOME/.linuxbrew/Homebrew" ]; then
          git clone https://github.com/Homebrew/brew "$HOME/.linuxbrew/Homebrew"
        fi
        mkdir -p "$HOME/.linuxbrew/bin"
        ln -sf "$HOME/.linuxbrew/Homebrew/bin/brew" "$HOME/.linuxbrew/bin/brew"
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
        brew update --force --quiet
        chmod -R go-w "$(brew --prefix)/share/zsh" 2>/dev/null || true
      else
        error "Failed to install Homebrew."
        return 1
      fi
    fi
  fi

  ensure_brew_env
}

install_native_dependencies() {
  info "Checking native package manager and dependencies..."
  local pkg_mgr="unknown"

  if command -v apt-get >/dev/null 2>&1; then
    pkg_mgr="apt"
  elif command -v pacman >/dev/null 2>&1; then
    pkg_mgr="pacman"
  elif command -v dnf >/dev/null 2>&1; then
    pkg_mgr="dnf"
  elif command -v zypper >/dev/null 2>&1; then
    pkg_mgr="zypper"
  elif command -v apk >/dev/null 2>&1; then
    pkg_mgr="apk"
  fi

  info "Detected native package manager: $pkg_mgr"

  # Determine missing tools
  local missing_pkgs=()

  # Core tools
  ! command -v git >/dev/null 2>&1 && missing_pkgs+=("git")
  ! command -v tmux >/dev/null 2>&1 && missing_pkgs+=("tmux")
  ! command -v curl >/dev/null 2>&1 && missing_pkgs+=("curl")
  ! command -v stow >/dev/null 2>&1 && missing_pkgs+=("stow")

  # Modern CLI tools from Brewfile
  ! command -v nvim >/dev/null 2>&1 && missing_pkgs+=("neovim")
  ! command -v rg >/dev/null 2>&1 && missing_pkgs+=("ripgrep")
  ! (command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1) && missing_pkgs+=("fd")
  ! command -v fzf >/dev/null 2>&1 && missing_pkgs+=("fzf")
  ! (command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1) && missing_pkgs+=("bat")
  ! command -v zoxide >/dev/null 2>&1 && missing_pkgs+=("zoxide")
  ! (command -v eza >/dev/null 2>&1 || command -v lsd >/dev/null 2>&1) && missing_pkgs+=("eza")

  # Clipboard utilities (Linux only - macOS has pbcopy/pbpaste natively)
  if [[ "$MACHINE" == "Linux" ]]; then
    ! command -v wl-copy >/dev/null 2>&1 && missing_pkgs+=("wl-clipboard")
    ! command -v xclip   >/dev/null 2>&1 && missing_pkgs+=("xclip")
  fi

  if [ ${#missing_pkgs[@]} -eq 0 ]; then
    success "All core dependencies are already installed on your system."
    if command -v nvim >/dev/null 2>&1; then
      local nvim_minor
      nvim_minor="$(nvim --version 2>/dev/null | head -n1 | sed -E 's/.*v[0-9]+\.([0-9]+).*/\1/' || echo "")"
      if [[ -n "$nvim_minor" && "$nvim_minor" =~ ^[0-9]+$ && "$nvim_minor" -lt 10 ]]; then
        warn "Installed Neovim is v0.${nvim_minor}. Upgrading to Neovim >= 0.10 is recommended (see misc/nvim.md)."
      fi
    fi
    return 0
  fi

  info "Missing dependencies: ${missing_pkgs[*]}"

  if [ "$pkg_mgr" == "unknown" ]; then
    warn "No supported package manager detected. Please install missing tools manually: ${missing_pkgs[*]}"
    return 0
  fi

  # Check if sudo or root access is available
  local can_install=false
  if [ "$(id -u)" -eq 0 ]; then
    can_install=true
  elif command -v sudo >/dev/null 2>&1; then
    if sudo -n true 2>/dev/null; then
      can_install=true
    elif [ -t 0 ] && sudo -v 2>/dev/null; then
      can_install=true
    fi
  fi

  if [ "$can_install" == "false" ]; then
    warn "Sudo permissions not available to install packages automatically via $pkg_mgr."
    warn "Please install missing packages manually: ${missing_pkgs[*]}"
    if ! command -v stow >/dev/null 2>&1; then
      info "Note: Dotfiles will be symlinked using native fallback (stow not required)."
    fi
    return 0
  fi

  local do_install=true
  if [ -t 0 ]; then
    local ans
    read -rp "Install missing dependencies with $pkg_mgr? [Y/n, default Y]: " ans
    case "$ans" in
      [nN]|[nN][oO]) do_install=false ;;
      *) do_install=true ;;
    esac
  fi

  if [ "$do_install" == "true" ]; then
    local sudo_cmd=""
    [ "$(id -u)" -ne 0 ] && sudo_cmd="sudo"

    case "$pkg_mgr" in
      apt)
        local apt_pkgs=()
        local needs_neovim_ppa=false
        for p in "${missing_pkgs[@]}"; do
          case "$p" in
            fd) apt_pkgs+=("fd-find") ;;
            neovim)
              apt_pkgs+=("neovim")
              needs_neovim_ppa=true
              ;;
            *) apt_pkgs+=("$p") ;;
          esac
        done
        if [ "$needs_neovim_ppa" == "true" ]; then
          if ! command -v add-apt-repository >/dev/null 2>&1; then
            info "Installing software-properties-common for PPA support..."
            $sudo_cmd apt-get update -y && $sudo_cmd apt-get install -y software-properties-common || true
          fi
          if command -v add-apt-repository >/dev/null 2>&1; then
            info "Adding Neovim PPA to ensure Neovim >= 0.10 is installed on Ubuntu/Debian..."
            $sudo_cmd add-apt-repository -y ppa:neovim-ppa/unstable || warn "Failed to add Neovim PPA, falling back to default repos."
          fi
        fi
        info "Running: $sudo_cmd apt-get update && $sudo_cmd apt-get install -y ${apt_pkgs[*]}"
        $sudo_cmd apt-get update -y && $sudo_cmd apt-get install -y "${apt_pkgs[@]}" || warn "Some packages failed to install via apt."
        ;;
      pacman)
        info "Running: $sudo_cmd pacman -Sy --noconfirm ${missing_pkgs[*]}"
        $sudo_cmd pacman -Sy --noconfirm "${missing_pkgs[@]}" || warn "Some packages failed to install via pacman."
        ;;
      dnf)
        local dnf_pkgs=()
        for p in "${missing_pkgs[@]}"; do
          case "$p" in
            fd) dnf_pkgs+=("fd-find") ;;
            *) dnf_pkgs+=("$p") ;;
          esac
        done
        info "Running: $sudo_cmd dnf install -y ${dnf_pkgs[*]}"
        $sudo_cmd dnf install -y "${dnf_pkgs[@]}" || warn "Some packages failed to install via dnf."
        ;;
      apk)
        info "Running: $sudo_cmd apk add ${missing_pkgs[*]}"
        $sudo_cmd apk add "${missing_pkgs[@]}" || warn "Some packages failed to install via apk."
        ;;
      zypper)
        info "Running: $sudo_cmd zypper install -y ${missing_pkgs[*]}"
        $sudo_cmd zypper install -y "${missing_pkgs[@]}" || warn "Some packages failed to install via zypper."
        ;;
    esac
    success "Native package installation step finished."
  fi
}

install_dependencies() {
  local brew_mode="$1"
  local install_casks="$2"

  ensure_brew_env

  local use_brew=false

  if [ "$brew_mode" == "brew" ]; then
    use_brew=true
  elif [ "$brew_mode" == "native" ]; then
    use_brew=false
  else
    # Auto mode:
    if command -v brew >/dev/null 2>&1; then
      info "Homebrew detected on system. Using Homebrew for dependencies..."
      use_brew=true
    else
      # Homebrew is not installed. Do NOT force it!
      if [ -t 0 ]; then
        info "Homebrew is not installed."
        echo -e "${BLUE}[INFO]${NC} Choose package manager strategy:" >&2
        echo -e "  ${YELLOW}1)${NC} Use Native package manager fallback (apt/pacman/etc.) [Default]" >&2
        echo -e "  ${YELLOW}2)${NC} Install Homebrew (Linuxbrew)" >&2
        local choice_pm
        read -rp "Select option [1-2, default 1]: " choice_pm
        case "$choice_pm" in
          2) use_brew=true ;;
          *) use_brew=false ;;
        esac
      else
        info "Homebrew not found. Using native package manager fallback..."
        use_brew=false
      fi
    fi
  fi

  if [ "$use_brew" == "true" ]; then
    if ! command -v brew >/dev/null 2>&1; then
      install_homebrew
    fi

    if command -v brew >/dev/null 2>&1; then
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

      # Clipboard utilities are only needed on Linux; macOS provides pbcopy.
      if [[ "$MACHINE" == "Linux" ]]; then
        local clipboard_pkgs=()
        ! command -v wl-copy >/dev/null 2>&1 && clipboard_pkgs+=("wl-clipboard")
        ! command -v xclip >/dev/null 2>&1 && clipboard_pkgs+=("xclip")
        if [ ${#clipboard_pkgs[@]} -gt 0 ]; then
          brew install "${clipboard_pkgs[@]}" || warn "Some clipboard packages failed to install. Continuing..."
        fi
      fi

      if [ "$install_casks" == "true" ] && [ -f "Brewfile.cask" ]; then
        info "Installing optional Cask packages from Brewfile.cask..."
        brew bundle install --file=Brewfile.cask || warn "Some Cask packages failed to install. Continuing script execution..."
        success "Cask package installation step finished."
      fi
    else
      warn "Homebrew could not be initialized. Falling back to native package manager..."
      install_native_dependencies
    fi
  else
    install_native_dependencies
  fi
}

# ==============================================================================
# Installation Functions
# ==============================================================================

update_submodules() {
  info "Updating Git submodules..."
  if git submodule update --init --recursive 2>/dev/null; then
    success "Submodules updated."
  else
    warn "Some or all Git submodules could not be updated. Continuing script execution..."
  fi
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
  local abs_dotfiles
  abs_dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

  while [ $retry -lt $max_retries ]; do
    local exit_code=0
    local stow_err
    stow_err=$(stow -d "$abs_dotfiles" -t "$HOME" --restow "$package" 2>&1) || exit_code=$?

    if [ $exit_code -eq 0 ]; then
      return 0
    fi

    if echo "$stow_err" | grep -qiE "would cause conflicts|existing target"; then
      info "Stow detected conflicts for package '$package'. Resolving..."

      local conflicts
      conflicts=$(echo "$stow_err" | awk '/^[[:space:]]*\*[[:space:]]/ {
        if (match($0, /over existing target ([^ ]+)/, m)) {
          print m[1];
        } else if (match($0, /:[[:space:]]*([^ ]+)[[:space:]]*$/, m)) {
          print m[1];
        }
      }' | sort -u)

      if [ -z "$conflicts" ]; then
        warn "Failed to parse specific Stow conflicts from output:"
        echo "$stow_err"
        return 1
      fi

      for rel_path in $conflicts; do
        local target_file="$HOME/$rel_path"
        local source_file="$abs_dotfiles/$package/$rel_path"

        if [ -e "$target_file" ] || [ -L "$target_file" ]; then
          if [ -f "$target_file" ] && [ -f "$source_file" ] && cmp -s "$target_file" "$source_file"; then
            warn "Removing identical existing file: $target_file"
            rm -f "$target_file"
          else
            local backup_file="${target_file}.backup"
            warn "Backing up conflicting target: $target_file -> $backup_file"
            mv "$target_file" "$backup_file"
          fi
        fi
      done

      retry=$((retry + 1))
    else
      warn "Stow failed with non-conflict error:"
      echo "$stow_err"
      return 1
    fi
  done

  warn "Failed to resolve Stow conflicts for package '$package' after $max_retries attempts."
  return 1
}

symlink_package_fallback() {
  local package="$1"
  local abs_package_dir
  abs_package_dir="$(cd "$package" && pwd -P)"
  info "Using native symlink fallback for package '$package'..."

  (
    cd "$abs_package_dir" || return 1
    find . -type f -o -type l | while read -r file; do
      local rel_path="${file#./}"
      local target_file="$HOME/$rel_path"
      local source_file="$abs_package_dir/$rel_path"
      local target_dir
      target_dir="$(dirname "$target_file")"

      mkdir -p "$target_dir"
      if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        if [ -f "$target_file" ] && cmp -s "$target_file" "$source_file"; then
          rm -f "$target_file"
        else
          local backup_file="${target_file}.backup"
          warn "Backing up conflicting target: $target_file -> $backup_file"
          mv "$target_file" "$backup_file"
        fi
      fi
      ln -sf "$source_file" "$target_file"
    done
  )
  success "Package '$package' symlinked via native fallback."
}

symlink_package() {
  local package="$1"
  if command -v stow >/dev/null 2>&1; then
    if ! run_stow_safe "$package"; then
      warn "GNU Stow encountered an error. Falling back to native symlink for package '$package'..."
      symlink_package_fallback "$package"
    fi
  else
    symlink_package_fallback "$package"
  fi
}

select_environment() {
  local input_env="$1"

  # Normalize input arguments
  case "$input_env" in
    --mac|-mac|mac) echo "mac"; return ;;
    --wsl|-wsl|wsl) echo "wsl"; return ;;
    --dms|-dms|dms) echo "dms"; return ;;
    --i3|-i3|i3) echo "i3"; return ;;
    --none|-none|none|--common|common) echo "none"; return ;;
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
    elif [[ "$IS_WSL" == "true" ]]; then
      echo -e "  ${YELLOW}1)${NC} WSL - Terminal & Base Configuration (common) [Recommended]" >&2
      echo -e "  ${YELLOW}2)${NC} Wayland - DankMaterialShell (dms)" >&2
      echo -e "  ${YELLOW}3)${NC} X11 - i3 Window Manager (i3)" >&2
      echo -e "  ${YELLOW}4)${NC} Only Base Configuration (common)" >&2
      local choice
      read -rp "Select option [1-4, default 1]: " choice
      case "$choice" in
        2) echo "dms" ;;
        3) echo "i3" ;;
        4) echo "none" ;;
        *) echo "wsl" ;;
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
    elif [[ "$IS_WSL" == "true" ]]; then
      echo "wsl"
    else
      echo "none"
    fi
  fi
}

symlink_dotfiles() {
  local target_env="$1"

  clean_invalid_symlinks

  info "Symlinking base package (common)..."
  symlink_package common

  if [[ "$target_env" == "mac" ]]; then
    info "Symlinking macOS package (macos)..."
    if [ -d "macos" ]; then symlink_package macos; fi
  elif [[ "$target_env" == "dms" ]]; then
    info "Symlinking Wayland package (DankMaterialShell)..."
    if [ -d "wayland-dms" ]; then symlink_package wayland-dms; fi
  elif [[ "$target_env" == "i3" ]]; then
    info "Symlinking X11 package (i3)..."
    if [ -d "x11-i3" ]; then symlink_package x11-i3; fi
  elif [[ "$target_env" == "wsl" ]]; then
    info "WSL configuration active (using base package 'common' with WSL optimizations)."
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
    # If in WSL, link into Windows VS Code settings as well if accessible
    if [[ "$IS_WSL" == "true" ]] && [ -d "/mnt/c/Users" ]; then
      for win_user in /mnt/c/Users/*; do
        local win_code_dir="$win_user/AppData/Roaming/Code/User"
        if [ -d "$win_code_dir" ]; then
          target_dirs+=("$win_code_dir")
        fi
      done
    fi
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
  elif command -v code.cmd >/dev/null 2>&1; then
    cli_cmd="code.cmd"
  elif command -v code.exe >/dev/null 2>&1; then
    cli_cmd="code.exe"
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
  local plugins_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins"
  local tpm_dir="$plugins_dir/tpm"
  if [ ! -x "$tpm_dir/tpm" ]; then
    info "Installing Tmux Plugin Manager (TPM)..."
    mkdir -p "$plugins_dir"
    if [ -d "$tpm_dir" ]; then
      if [ -n "$(find "$tpm_dir" -mindepth 1 -print -quit 2>/dev/null)" ]; then
        warn "TPM directory exists but is incomplete: $tpm_dir"
        return 0
      fi
      rmdir "$tpm_dir"
    fi
    if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" 2>/dev/null; then
      success "TPM installed."
    else
      warn "Failed to clone TPM repository (check network access). Continuing..."
    fi
  fi
}

# ==============================================================================
# Main Execution
# ==============================================================================

main() {
  local target_env=""
  local install_casks="false"
  local brew_mode="auto"

  # Parse CLI arguments
  for arg in "$@"; do
    case "$arg" in
      --wsl|-wsl|wsl) target_env="wsl" ;;
      --dms|-dms|dms) target_env="dms" ;;
      --i3|-i3|i3) target_env="i3" ;;
      --mac|-mac|mac) target_env="mac" ;;
      --none|-none|none|--common|common) target_env="none" ;;
      --brew|-b) brew_mode="brew" ;;
      --no-brew|--native|-n) brew_mode="native" ;;
      --casks|-c|--cask) install_casks="true" ;;
    esac
  done

  if [ -z "$target_env" ]; then
    target_env="$(select_environment "$1")"
  fi

  # In interactive mode on macOS, if flag was not explicitly given, prompt the user
  if [ "$install_casks" == "false" ] && [ -t 0 ] && [[ "$MACHINE" == "Mac" ]]; then
    echo -e "${BLUE}[INFO]${NC} Do you want to install optional Cask packages (fonts/GUI apps)? [y/N]: " >&2
    local choice_cask
    read -rp "Select option [y/N, default N]: " choice_cask
    case "$choice_cask" in
      [yY]|[yY][eE][sS]) install_casks="true" ;;
      *) install_casks="false" ;;
    esac
  fi

  local wsl_status="false"
  [ "$IS_WSL" == "true" ] && wsl_status="true (${WSL_DISTRO_NAME:-Linux})"
  info "Starting dotfiles installation on system: $MACHINE (Target: $target_env | WSL: $wsl_status | Package mode: $brew_mode)"

  install_dependencies "$brew_mode" "$install_casks"
  update_submodules
  symlink_dotfiles "$target_env"
  setup_vscodium
  setup_tpm

  echo ""
  success "Installation completed successfully!"
}

# Execute the script
main "$@"
