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

check_dependencies() {
  info "Comprobando dependencias esenciales..."
  
  local deps=("git" "stow")
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      error "Dependencia '$dep' no está instalada. Por favor, instálala antes de continuar."
      exit 1
    fi
  done
  success "Todas las dependencias core están instaladas."
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
  info "Vinculando dotfiles con GNU Stow..."
  # Usamos --restow para asegurar idempotencia (limpia links muertos y recrea)
  stow --restow .
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
  info "Iniciando instalación de dotfiles en sistema: $MACHINE"
  
  check_dependencies
  update_submodules
  symlink_dotfiles
  setup_vscodium
  
  echo ""
  success "¡Instalación completada con éxito!"
}

# Ejecutar el script
main
