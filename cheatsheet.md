# 🚀 Chuleta de Atajos Unificados (Cheat Sheet)

Guarda esta guía como referencia rápida para tu nuevo flujo de trabajo unificado entre **Neovim, IntelliJ (IdeaVim), Tmux y Zsh**.

---

## 🪟 Gestión de Ventanas (Neovim & IntelliJ)
Tanto en Neovim como en IntelliJ (IdeaVim), tu tecla líder (`<leader>`) es la **Barra Espaciadora (`Space`)**.

| Acción | Atajo |
| :--- | :--- |
| **Dividir Verticalmente** | `<Space> + s + v` |
| **Dividir Horizontalmente** | `<Space> + s + h` |
| **Cerrar División (Unsplit)** | `<Space> + w + c` |
| **Moverse entre Paneles** | `Ctrl + h / j / k / l` |
| **Siguiente Pestaña (Tab)** | `<Tab>` *(IdeaVim)* |
| **Pestaña Anterior** | `<Shift> + <Tab>` *(IdeaVim)* |

---

## ✏️ Edición de Código
Estos atajos te permiten editar código fluidamente sin usar las flechas del teclado.

| Acción | Atajo |
| :--- | :--- |
| **Mover línea hacia abajo** | `Alt + j` |
| **Mover línea hacia arriba** | `Alt + k` |
| **Comentar línea** | `Ctrl + /` (o `<Space> + /`) |
| **Formatear Código** | `<Space> + l` *(IdeaVim / LSP)* |
| **Indentación Rápida** | `>` o `<` *(En modo visual)* |

---

## 🧭 Navegación Global (Tmux)
Tu prefijo de Tmux es **`Ctrl + Space`**.

| Acción | Atajo |
| :--- | :--- |
| **Dividir panel vertical** | `Prefix` luego `v` |
| **Dividir panel horizontal** | `Prefix` luego `s` |
| **Crear nueva ventana (Tab)** | `Prefix` luego `c` |
| **Navegar a la última ventana**| `Prefix` luego `^` |
| **Recargar Configuración** | `Prefix` luego `r` |

> [!TIP]
> **El superpoder de vim-tmux-navigator:**
> No necesitas el prefijo para saltar entre paneles de Tmux y Neovim. Solo usa **`Ctrl + h/j/k/l`** y el cursor volará libremente entre tu código y tu terminal.

---

## 🔎 Búsqueda y Archivos (IntelliJ / Telescope)
Atajos inspirados en el flujo de IntelliJ, mapeados al líder.

| Acción | Atajo |
| :--- | :--- |
| **Buscar Archivo (Go to File)**| `<Space> + f + f` |
| **Buscar Texto (Find in Path)**| `<Space> + f + s` |
| **Archivos Recientes** | `<Space> + f + r` |
| **Ir a Declaración** | `<Space> + g + d` |

---

## 💻 Terminal (Zsh)
Ahora que habilitamos el modo Vi, tu terminal se comporta como un mini-vim.

| Acción | Atajo |
| :--- | :--- |
| **Navegar en Menú (fzf/zsh)** | `Ctrl + h / j / k / l` |
| **Modo Normal (Vi mode)** | `Esc` |
| **Alternar `sudo` (Toggle)** | `Alt + s` (o `Esc` luego `s`) |
| **Buscar en historial** | `Ctrl + r` (vía FZF) |
