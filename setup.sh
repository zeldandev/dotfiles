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

# ==============================================================================
# Core Dependencies
# ==============================================================================

install_dependencies() {
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

  info "Installing packages from Brewfile..."
  if [ -f "Brewfile" ]; then
    brew bundle install --file=Brewfile
    success "Packages installed successfully."
  else
    warn "Brewfile not found."
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

symlink_dotfiles() {
  local target_env="$1"
  
  info "Symlinking base package (common)..."
  stow --restow common
  
  if [[ "$MACHINE" == "Mac" ]]; then
    info "macOS detected. Symlinking macos package..."
    if [ -d "macos" ]; then stow --restow macos; fi
  else
    if [[ "$target_env" == "--dms" ]]; then
      info "Symlinking Wayland package (DankMaterialShell)..."
      if [ -d "wayland-dms" ]; then stow --restow wayland-dms; fi
    elif [[ "$target_env" == "--i3" ]]; then
      info "Symlinking X11 package (i3)..."
      if [ -d "x11-i3" ]; then stow --restow x11-i3; fi
    else
      warn "No graphical environment specified for Linux (--dms or --i3). Only base was installed."
      info "Use './setup.sh --dms' or './setup.sh --i3' for complete environments."
    fi
  fi
  
  success "Dotfiles symlinked successfully."
}

setup_vscodium() {
  if [ -x "./.config/VSCodium/User/install.sh" ]; then
    info "Configuring VSCodium..."
    ./.config/VSCodium/User/install.sh
    success "VSCodium configured."
  fi
}

# ==============================================================================
# Main Execution
# ==============================================================================

main() {
  local target_env="$1"
  info "Starting dotfiles installation on system: $MACHINE"
  
  install_dependencies
  update_submodules
  symlink_dotfiles "$target_env"
  setup_vscodium
  
  echo ""
  success "Installation completed successfully!"
}

# Execute the script
main "$1"
