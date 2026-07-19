# 🚀 Chuleta de Atajos Unificados (Cheat Sheet)

Guarda esta guía como referencia rápida para tu flujo de trabajo unificado entre **Tmux, Neovim / IntelliJ (IdeaVim) y Zsh**.

---

## 🧭 1. Tmux (Navegación Global & Terminales)

Tu tecla prefijo de Tmux es **`Ctrl + Space`**.

### 🪟 Paneles y Ventanas

| Acción | Atajo |
| :--- | :--- |
| **Dividir panel vertical** | `Prefix` luego `v` |
| **Dividir panel horizontal** | `Prefix` luego `s` |
| **Crear nueva ventana (Tab)** | `Prefix` luego `c` |
| **Maximizar / Restaurar panel (Zoom)** | `Prefix` luego `z` |
| **Navegar a la última ventana** | `Prefix` luego `^` |
| **Ir a ventana por número** | `Prefix` luego `1`..`9` |
| **Renombrar ventana actual** | `Prefix` luego `,` |
| **Renombrar sesión actual** | `Prefix` luego `$` |
| **Redimensionar panel** | `Prefix` luego `H` / `J` / `K` / `L` |
| **Recargar configuración** | `Prefix` luego `r` |
| **Ver chuleta en popup flotante** | `Prefix` luego `/` |

---

### 📋 Modo Copia (Vi Mode) & Portapapeles

| Acción | Atajo |
| :--- | :--- |
| **Entrar en Modo Copia** | `Prefix` luego `[` (o desplazar rueda del ratón) |
| **Iniciar Selección de texto** | `v` *(dentro del modo copia)* |
| **Seleccionar línea completa** | `V` *(dentro del modo copia)* |
| **Copiar al portapapeles del sistema** | `y` o `Enter` *(copia y sale)* |
| **Cancelar / Salir del modo copia** | `Esc` o `q` |

---

### 💾 Gestión de Plugins y Sesiones (TPM & Resurrect)

| Acción | Atajo |
| :--- | :--- |
| **Guardar estado de la sesión** | `Prefix` luego `Ctrl + s` |
| **Restaurar sesión guardada** | `Prefix` luego `Ctrl + r` |
| **Instalar plugins de Tmux (TPM)** | `Prefix` luego `I` *(Mayúscula)* |
| **Actualizar plugins de Tmux** | `Prefix` luego `U` |

---

### 💡 Trucos Pro de Tmux

> [!TIP]
> **1. Navegación Fluida (`Ctrl + h/j/k/l`):**
> Gracias a `vim-tmux-navigator`, no necesitas presionar el prefijo para saltar entre paneles de Tmux y divisiones de Neovim. Usa **`Ctrl + h / j / k / l`** directamente y el cursor volará entre el código y la terminal.

> [!TIP]
> **2. Zoom Temporal (`Prefix + z`):**
> Si estás en una ventana dividida en varios paneles y necesitas concentrarte en una terminal a pantalla completa, pulsa `Prefix + z`. Pulsa de nuevo `Prefix + z` para restaurar la distribución original.

> [!TIP]
> **3. Persistencia de Sesión (`tmux-resurrect`):**
> Guarda el estado de tus terminales con `Prefix + Ctrl + s`. Tras reiniciar el equipo, pulsa `Prefix + Ctrl + r` para restaurar todas tus ventanas, paneles y carpetas de trabajo.

---

## ⚡ 2. Neovim & IntelliJ (IdeaVim)

Tu tecla líder (`<leader>`) en Neovim e IntelliJ es la **Barra Espaciadora (`Space`)**.

### 🪟 Ventanas, Divisiones y Navegador de Archivos

| Acción | Atajo |
| :--- | :--- |
| **Dividir Verticalmente** | `<Space> + s + v` |
| **Dividir Horizontalmente** | `<Space> + s + h` |
| **Cerrar División (Unsplit)** | `<Space> + w + c` |
| **Abrir/Cerrar Árbol de Archivos** | `Ctrl + n` |
| **Navegar entre Divisiones** | `Ctrl + h / j / k / l` |
| **Siguiente Pestaña (Tab)** | `<Tab>` |
| **Pestaña Anterior** | `<Shift> + <Tab>` |
| **Cerrar Pestaña Actual** | `<Space> + b + k` |

---

### 🔎 Búsqueda y Navegación de Código (LSP / Telescope / IdeaVim)

| Acción | Atajo |
| :--- | :--- |
| **Buscar Archivo por Nombre** | `<Space> + f + f` |
| **Buscar Texto en el Proyecto (Grep)** | `<Space> + f + s` |
| **Archivos Recientes** | `<Space> + f + r` |
| **Ir a Declaración / Definición** | `<Space> + g + d` |
| **Ir a Implementación** | `<Space> + g + i` |
| **Volver Atrás / Ir Adelante** | `<Space> + g + b` / `<Space> + g + f` |
| **Siguiente / Anterior Coincidencia** | `n` / `N` *(auto-centrado en pantalla)* |

---

### ✏️ Edición, Refactorización y Portapapeles

| Acción | Atajo |
| :--- | :--- |
| **Mover línea hacia abajo** | `Alt + j` |
| **Mover línea hacia arriba** | `Alt + k` |
| **Comentar / Descomentar línea** | `Ctrl + /` (o `<Space> + /`) |
| **Formatear Código** | `<Space> + l` |
| **Optimizar Imports (Java/TS/Go)** | `<Space> + o` |
| **Renombrar Símbolo / Variable** | `<Space> + c + r` |
| **Indentación Visual Continua** | `>` o `<` *(mantiene la selección visual)* |
| **Copiar al Portapapeles del Sistema** | `<Space> + y` *(en modo visual)* |
| **Pegar desde Portapapeles Sistema** | `<Space> + p` |

---

### 💡 Trucos Pro de Vim / Neovim

> [!TIP]
> **1. Búsqueda Auto-centrada (`nzzv`):**
> Al buscar palabras con `/` o utilizar `n` / `N`, el cursor se posiciona automáticamente en el centro de la pantalla para evitar perder el contexto visual del código.

> [!TIP]
> **2. Multicursor en IntelliJ (`Ctrl + n`):**
> En IdeaVim, selecciona una palabra y presiona `Ctrl + n` para añadir la siguiente coincidencia con un cursor secundario y editar múltiples instancias simultáneamente. Usa `Ctrl + x` para omitir una coincidencia.

> [!TIP]
> **3. Mantener Selección Visual en Indentación (`>` o `<`):**
> Al sangrar código en modo visual con `>` o `<`, la selección no se pierde, permitiéndote presionar `>` repetidamente sin re-seleccionar.

---

## 💻 3. Zsh (Terminal Interactiva & Modo Vi)

Tu terminal Zsh cuenta con **Modo Vi activado**, autocompletado inteligente y vistas previas.

### ⌨️ Modo Vi y Edición de Comandos

| Acción | Atajo |
| :--- | :--- |
| **Entrar en Modo Normal (Vi mode)** | `Esc` *(el cursor cambia a bloque █)* |
| **Volver a Modo Insert** | `i` o `a` *(el cursor cambia a barra vertical \|)* |
| **Aceptar Sugerencia (Autosuggestion)**| `Ctrl + y` (o `Flecha Derecha`) |
| **Borrar palabra anterior** | `Ctrl + w` |
| **Borrar desde el cursor al inicio** | `Ctrl + u` |
| **Limpiar pantalla** | `Ctrl + l` |
| **Alternar `sudo` al inicio del comando**| `Alt + s` (o `Esc` luego `s`) |

---

### 🔎 Búsquedas Interactivas con FZF

| Acción | Atajo |
| :--- | :--- |
| **Buscar Archivos con Preview Sintáctico** | `Ctrl + t` *(con vista previa en `bat`)* |
| **Navegar Directorios con Árbol** | `Alt + c` *(con vista previa en `eza`/`lsd`)* |
| **Buscar en Historial de Comandos** | `Ctrl + r` *(filtrado difuso con FZF)* |
| **Navegar en Menú de Autocompletado** | `Ctrl + h / j / k / l` *(tras pulsar `Tab`)* |

---

### 🚀 Navegación Rápida y Aliases Útiles

| Comando | Función |
| :--- | :--- |
| **`z <carpeta>`** | Salto inteligente a directorios frecuentes con Zoxide (ej. `z dotfiles`) |
| **`z -`** | Volver al directorio anterior |
| **`ls` / `ll` / `lt`** | Listado inteligente con iconos (`eza`/`lsd`), árbol y formatos largos |
| **`lg`** | Abrir la interfaz visual de Git (**Lazygit**) |
| **`chuleta`** | Abrir este documento de atajos en cualquier momento |

---

### 💡 Trucos Pro de Zsh

> [!TIP]
> **1. Indicador del Modo Vi:**
> Fíjate en la forma del cursor mientras escribes: si es una barra vertical `|` estás insertando texto; si presionas `Esc` cambia a un bloque sólido `█`, permitiéndote moverte con `h/j/k/l`, borrar con `x` o cambiar palabras con `cw` exactamente igual que en Neovim.

> [!TIP]
> **2. Salto Inteligente con `z`:**
> No necesitas escribir rutas completas como `cd ~/proyectos/web/backend`. Basta con escribir `z back` y Zoxide aprenderá tus hábitos para llevarte instantáneamente.

> [!TIP]
> **3. Inserción Rápida de `sudo` (`Alt + s`):**
> Si escribiste un comando largo y olvidaste ejecutarlo como superusuario, no lo borres. Presiona `Alt + s` y Zsh insertará `sudo ` automáticamente al principio de la línea.
