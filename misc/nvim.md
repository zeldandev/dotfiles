# 📝 Guía de Neovim

Esta guía documenta la instalación, gestión de plugins y atajos clave de la configuración moderna de **Neovim** incluida en estos dotfiles (basada en **Lazy.nvim** con tema **Rosé Pine**, integración **Tmux**, **LSP-zero**, **Telescope** y **Conform**).

---

## 🚀 1. Instalación de Neovim (>= 0.10)

> [!IMPORTANT]
> Los plugins modernos como `nvim-treesitter` requieren **Neovim 0.10 o superior**. En Ubuntu/Debian estándar los repositorios suelen incluir versiones antiguas (0.9.x).

### Opción A: Binario oficial precompilado (Recomendado en Linux)
Descarga la versión estable oficial y la enlaza en `/usr/local/bin`:

```bash
# Descargar y extraer en /opt
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
```

### Opción B: Mediante PPA oficial (Ubuntu)
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y
```

### Opción C: Mediante Homebrew (macOS o Linux)
```bash
brew install neovim
```

Comprueba que la versión instalada sea `>= 0.10`:
```bash
nvim --version
```

---

## ⚙️ 2. Estructura de la Configuración

La configuración se encuentra en `common/.config/nvim/` y se enlaza mediante `stow` o el script `./setup.sh`:

```text
~/.config/nvim/
├── init.lua                  # Punto de entrada y polyfills de compatibilidad
├── lazyvim.json              # Configuración base de Lazy
├── lazy-lock.json            # Bloqueo de versiones exactas de plugins
└── lua/
    ├── core/
    │   ├── init.lua          # Carga opciones, lazy y keymaps
    │   ├── options.lua       # Opciones de Neovim (sangría, clipboard, netrw)
    │   ├── keymap.lua        # Atajos de teclado generales (splits, mover líneas)
    │   └── lazy.lua          # Bootstrap y arranque de lazy.nvim
    └── plugins/              # Especificaciones modulares de plugins
        ├── colorscheme.lua   # Tema Rosé Pine
        ├── lsp.lua           # LSP-zero, Mason, Mason-lspconfig, Cmp, LuaSnip
        ├── conform.lua       # Formateador de código
        ├── treesitter.lua    # Resaltado y parseo de sintaxis
        ├── telescope.lua     # Buscador interactivo
        ├── neogit.lua        # Interfaz de Git (Neogit + Diffview)
        ├── gitsigns.lua      # Indicadores de cambios Git y blame en línea
        ├── nvim-tree.lua     # Explorador de archivos
        ├── lualine.lua       # Barra de estado inferior
        ├── which-key.lua     # Popup interactivo de ayuda de atajos
        ├── tmux-navigation.lua # Navegación unificada con Tmux
        └── ...
```

---

## 📦 3. Gestión de Plugins (`lazy.nvim`)

Los plugins se gestionan con **Lazy.nvim**.

* **Abrir panel de Lazy**: `:Lazy`
* **Actualizar y sincronizar plugins**: `:Lazy sync`
* **Comprobar salud general del entorno**: `:checkhealth`

---

## ⌨️ 4. Atajos de Teclado Principales

Tu tecla líder (`<leader>`) es la **Barra Espaciadora (`Space`)**.

### 🧭 Navegación entre paneles (Tmux + Neovim)
| Atajo | Acción |
| --- | --- |
| `Ctrl + h` | Moverse a la ventana / panel izquierdo |
| `Ctrl + j` | Moverse a la ventana / panel inferior |
| `Ctrl + k` | Moverse a la ventana / panel superior |
| `Ctrl + l` | Moverse a la ventana / panel derecho |

### 🗂️ Explorador de Archivos (`NvimTree`)
| Atajo | Acción |
| --- | --- |
| `Ctrl + n` | Abrir / cerrar NvimTree |
| `<leader> + ef` | Abrir NvimTree enfocado en el archivo actual |

### 🔍 Búsqueda (`Telescope`)
| Atajo | Acción |
| --- | --- |
| `<leader> + ff` | Buscar archivos por nombre en el proyecto |
| `<leader> + fr` | Buscar archivos recientes |
| `<leader> + fs` | Búsqueda global de texto (*live grep*) |
| `<leader> + fc` | Buscar la palabra bajo el cursor en todo el proyecto |
| `<leader> + fb` | Listar y cambiar entre buffers abiertos |
| `<leader> + fg` | Buscar entre archivos rastreados por Git |
| `<leader> + vh` | Buscar en la ayuda de Vim/Neovim |

### 💡 LSP (Lenguajes y Autocompletado)
| Atajo | Acción |
| --- | --- |
| `gd` | Ir a la definición del símbolo |
| `gr` / `<leader> + vrr` | Ver referencias del símbolo |
| `K` | Ver documentación flotante (*hover*) |
| `[d` | Ir al diagnóstico/error anterior |
| `]d` | Ir al diagnóstico/error siguiente |
| `<leader> + vd` | Abrir lista de diagnósticos |
| `<leader> + vca` | Acciones de código (*code action*) |
| `<leader> + vrn` | Renombrar símbolo (*rename*) |
| `Ctrl + h` (modo insertar) | Ayuda de firma de función (*signature help*) |
| `<leader> + l` | Formatear archivo actual con `conform` |

### 🐙 Git (`Neogit` / `LazyGit` / `Gitsigns`)
| Atajo | Acción |
| --- | --- |
| `<leader> + gs` | Abrir interfaz de Neogit |
| `<leader> + gc` | Commit interactivo en Neogit |
| `<leader> + gp` | Git pull en Neogit |
| `<leader> + gP` | Git push en Neogit |
| `<leader> + gb` | Listar ramas con Telescope |
| `<leader> + gB` | Mostrar Git Blame de la línea actual (`gitsigns`) |
| `<leader> + gg` | Abrir terminal con LazyGit flotante |

### ✂️ Ventanas y Edición
| Atajo | Acción |
| --- | --- |
| `<leader> + sv` | Dividir ventana verticalmente |
| `<leader> + sh` | Dividir ventana horizontalmente |
| `Alt + j` / `Alt + k` | Mover línea o selección arriba/abajo (normal/visual/insert) |
| `<leader> + mp` | Previsualizar archivo Markdown en el navegador |
| `<leader> + ?` | Abrir chuleta flotante de atajos (`cheatsheet.md`) |
