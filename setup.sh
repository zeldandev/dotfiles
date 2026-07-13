#!/usr/bin/env bash

# Salir inmediatamente si un comando falla
set -e

# ==============================================================================
# Variables y Utilidades
# ==============================================================================

# Colores para los mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Detectar Sistema Operativo
OS="$(uname -s)"
case "$OS" in
  Linux*)     MACHINE="Linux" ;;
  Darwin*)    MACHINE="Mac" ;;
  CYGWIN*|MINGW*|MSYS*) MACHINE="Windows" ;;
  *)          MACHINE="UNKNOWN:${OS}" ;;
esac

# ==============================================================================
# Dependencias Core
# ==============================================================================

install_dependencies() {
  info "Comprobando gestor de paquetes (Homebrew)..."
  
  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew no está instalado. Instalando automáticamente (puede pedir contraseña sudo)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Añadir brew al PATH temporalmente para que el script pueda continuar
    if [[ "$MACHINE" == "Linux" ]] && [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$MACHINE" == "Mac" ]] && [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  success "Homebrew detectado."

  info "Instalando paquetes desde Brewfile..."
  if [ -f "Brewfile" ]; then
    brew bundle install --file=Brewfile
    success "Paquetes instalados correctamente."
  else
    warn "No se encontró Brewfile."
  fi
}

# ==============================================================================
# Funciones de Instalación
# ==============================================================================

update_submodules() {
  info "Actualizando submódulos de Git..."
  git submodule update --init --recursive
  success "Submódulos actualizados."
}

symlink_dotfiles() {
  local target_env="$1"
  
  info "Vinculando paquete base (common)..."
  stow --restow common
  
  if [[ "$MACHINE" == "Mac" ]]; then
    info "Detectado macOS. Vinculando paquete macos..."
    if [ -d "macos" ]; then stow --restow macos; fi
  else
    if [[ "$target_env" == "--dms" ]]; then
      info "Vinculando paquete Wayland (DankMaterialShell)..."
      if [ -d "wayland-dms" ]; then stow --restow wayland-dms; fi
    elif [[ "$target_env" == "--i3" ]]; then
      info "Vinculando paquete X11 (i3)..."
      if [ -d "x11-i3" ]; then stow --restow x11-i3; fi
    else
      warn "No se especificó entorno gráfico para Linux (--dms o --i3). Solo se instaló la base."
      info "Usa './setup.sh --dms' o './setup.sh --i3' para entornos completos."
    fi
  fi
  
  success "Dotfiles vinculados correctamente."
}

setup_vscodium() {
  if [ -x "./.config/VSCodium/User/install.sh" ]; then
    info "Configurando VSCodium..."
    ./.config/VSCodium/User/install.sh
    success "VSCodium configurado."
  fi
}

# ==============================================================================
# Ejecución Principal
# ==============================================================================

main() {
  local target_env="$1"
  info "Iniciando instalación de dotfiles en sistema: $MACHINE"
  
  install_dependencies
  update_submodules
  symlink_dotfiles "$target_env"
  setup_vscodium
  
  echo ""
  success "¡Instalación completada con éxito!"
}

# Ejecutar el script
main "$1"
