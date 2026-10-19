# 🚀 Zeldan's Dotfiles

> A unified, keyboard-centric development environment for Linux and macOS —
> built for speed, modularity, and cross-platform consistency.

![Linux](https://img.shields.io/badge/OS-Linux-blue?style=flat-square&logo=linux)
![macOS](https://img.shields.io/badge/OS-macOS-black?style=flat-square&logo=apple)
![Neovim](https://img.shields.io/badge/Editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)
![Tmux](https://img.shields.io/badge/Multiplexer-Tmux-1BB91F?style=flat-square&logo=tmux&logoColor=white)
![Zsh](https://img.shields.io/badge/Shell-Zsh-F15A24?style=flat-square&logo=gnu-bash&logoColor=white)
![Stow](https://img.shields.io/badge/Managed%20by-GNU%20Stow-4E9A06?style=flat-square)

---

## ✨ What's Inside

The whole environment is tightly integrated: Neovim, Tmux, Zsh and the window
manager all share the same keybinding philosophy. Moving between a Neovim split
and a Tmux pane is the same gesture (`Ctrl+h/j/k/l`). The prompt, file previews,
fuzzy finders, and git interfaces are wired together out of the box.

| Layer | Tool | Role |
| :--- | :--- | :--- |
| **Shell** | Zsh + [Starship](https://starship.rs) | Fast, minimal prompt with Vi-mode and dynamic cursor |
| **Multiplexer** | Tmux + TPM | Persistent sessions, window/pane management, Rosé Pine theme |
| **Editor** | Neovim (Lua) | LSP, Tree-sitter, Telescope, lazy.nvim — see [nvim/README](common/.config/nvim/README.md) |
| **Terminal** | Kitty / iTerm2 | GPU-accelerated, Nerd Font support, Rosé Pine Moon theme |
| **File Navigation** | `zoxide` + `fzf` + `eza` | Smart `cd`, fuzzy search, tree listings with icons |
| **Git** | `lazygit` + `git-delta` | Terminal UI for git + beautiful side-by-side diffs |
| **Window Manager (X11)** | i3 + Polybar + Rofi | Keyboard-driven tiling WM for VM / X11 setups |
| **Window Manager (Wayland)** | DankMaterialShell | Wayland compositor shell for the main desktop |
| **IDE integration** | IdeaVim (`.ideavimrc`) | IntelliJ/JetBrains with Neovim-compatible bindings |
| **VS Code / VSCodium** | Settings + keybindings | Shared config auto-linked by the setup script |

---

## ⚙️ Installation

The [`setup.sh`](setup.sh) script is **idempotent** — safe to re-run at any time.
It auto-detects your OS and environment, installs dependencies, and symlinks
everything with **GNU Stow** (with a native fallback if Stow is not available).

### 1 — Clone

```bash
git clone https://github.com/zeldandev/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2 — Run the bootstrap script

```bash
# Interactive mode — the script will ask which environment to set up
./setup.sh

# Or pass a flag directly to skip the prompt:
./setup.sh --dms    # Main Linux desktop  (common + DankMaterialShell/Wayland)
./setup.sh --i3     # Virtual machine     (common + i3 / X11)
./setup.sh --wsl    # Windows Subsystem for Linux (common, WSL-optimized)
./setup.sh          # macOS               (auto-detected, common + macOS specifics)
./setup.sh --common # Base only           (common package, no WM)
```

#### Package manager options

```bash
./setup.sh --brew      # Force Homebrew (install it if missing)
./setup.sh --no-brew   # Force native package manager (apt / pacman / dnf / zypper / apk)
./setup.sh --casks     # Also install GUI apps & fonts from Brewfile.cask (macOS)
```

> [!NOTE]
> **Homebrew is optional.** If it is not detected, the script offers to install
> it or fall back to your system package manager. If `stow` is missing, a native
> `ln -sf` fallback is used automatically.

> [!TIP]
> Conflicting files are **never silently deleted** — they are renamed to
> `<file>.backup` before being replaced by a symlink.

### 3 — What the script does

```
1. Installs missing CLI dependencies (git, tmux, nvim, fzf, ripgrep, bat, eza, zoxide, lazygit …)
2. Updates Git submodules
3. Cleans up any stale legacy symlinks
4. Symlinks config files with GNU Stow (or native fallback)
5. Links VS Code / VSCodium settings and installs extensions (if installed)
6. Installs Tmux Plugin Manager (TPM)
```

After the first run, open Neovim (`nvim`) and lazy.nvim will automatically
install all plugins. Mason will then install the configured language servers.

---

## 📂 Repository Structure

```
dotfiles/
│
├── common/                         # ✅ Installed on EVERY machine
│   └── .config/
│       ├── nvim/                   # Neovim config (Lua, lazy.nvim) → see nvim/README.md
│       ├── tmux/tmux.conf          # Tmux config (TPM, vi-copy, Resurrect)
│       ├── kitty/                  # Kitty terminal themes & config
│       ├── shell/
│       │   ├── aliasrc             # Shared aliases (ls→eza, cat→bat, lg, chuleta …)
│       │   ├── envrc               # Environment variables (EDITOR, LANG, mise …)
│       │   └── pathrc              # PATH additions
│       ├── starship.toml           # Starship prompt config
│       └── VSCodium/               # VS Code / VSCodium settings & keybindings
│   ├── .zshrc                      # Zsh config (Vi-mode, fzf, zoxide, completions)
│   ├── .zprofile                   # Zsh login shell (Homebrew env, mise activate)
│   ├── .profile                    # POSIX profile (sourced by login shells)
│   ├── .ideavimrc                  # IdeaVim config for IntelliJ / JetBrains IDEs
│   └── .xsessionrc                 # X session startup script
│
├── wayland-dms/                    # 🖥️  Main Linux desktop (Wayland)
│   └── .config/DankMaterialShell/ # DankMaterialShell settings & Firefox CSS
│
├── x11-i3/                         # 🖥️  Virtual machine / X11 setup
│   ├── .config/i3/                 # i3 window manager config
│   ├── .config/polybar/            # Polybar status bar
│   ├── .config/rofi/               # Rofi launcher, powermenu, themes (Catppuccin)
│   ├── .config/picom/              # Picom compositor (shadows, blur, animations)
│   └── .local/bin/                 # Rofi helper scripts
│
├── macos/                          # 🍎 macOS only
│   └── .config/iterm2/             # iTerm2 config & profile
│
├── misc/                           # 📖 Helper scripts & documentation
│   ├── debian/                     # Debian / Ubuntu setup scripts
│   │   ├── 00_0-essential.sh       # Essential packages
│   │   ├── 00_1-i3-install.sh      # i3 + Polybar installation
│   │   ├── 00_2-gui-apps.sh        # GUI apps
│   │   ├── 00_3-set-zsh-default.sh # Set Zsh as default shell
│   │   ├── 01-linux-brew.sh        # Homebrew for Linux
│   │   ├── 05-Fonts.sh             # Nerd Fonts installer
│   │   ├── 07-mise-packages.sh     # mise (Node, Python, Go …) setup
│   │   └── 08-docker.sh            # Docker CE installation
│   ├── mac/mac-install.sh          # macOS post-install steps
│   ├── git.md                      # Git setup guide (GPG signing, SSH, Delta)
│   ├── ssh.md                      # SSH key setup guide
│   └── nvim.md                     # Neovim manual install guide (when PPA unavailable)
│
├── Brewfile                        # Core Homebrew formulas
├── Brewfile.cask                   # Optional GUI casks & Nerd Fonts
├── setup.sh                        # Idempotent bootstrap script
└── cheatsheet.md                   # Unified keybinding reference (Tmux + Neovim + Zsh)
```

---

## 🔧 Local / Machine-Specific Config

These files are sourced automatically but **never committed** (listed in
`.gitignore`). Create them in `$HOME` to add per-machine settings without
touching the repo:

| File | Sourced by | Purpose |
| :--- | :--- | :--- |
| `~/.profile.local` | `~/.profile` | System-wide env vars, generic paths |
| `~/.zprofile.local` | `~/.zprofile` | Zsh login init (machine-specific PATH, tokens) |
| `~/.zshrc.local` | `~/.zshrc` | Interactive Zsh: local aliases, functions, secrets |

> [!CAUTION]
> Never put API keys or tokens in tracked files. Use `~/.zshrc.local` instead —
> it is git-ignored and sourced automatically on every new shell.

---

## ⌨️ Unified Keybindings

All three environments share the same navigation muscle memory:

| Gesture | Everywhere |
| :--- | :--- |
| `Ctrl + h / j / k / l` | Move between Neovim splits **and** Tmux panes |
| `Space` | Leader key in Neovim and IdeaVim |
| `Ctrl + Space` | Tmux prefix |

### Quick cheatsheet access

| Where | How |
| :--- | :--- |
| **Neovim** | `<Space>?` — floating window with the full cheatsheet |
| **Tmux** | `Prefix + /` (`Ctrl+Space` then `/`) — popup overlay |
| **Zsh** | `chuleta` — opens cheatsheet.md in the terminal |
| **i3 (X11)** | `Super + c` — opens cheatsheet in a floating window |

📄 Full reference: [`cheatsheet.md`](cheatsheet.md)

---

## 📦 Core Dependencies

Installed automatically by `setup.sh` via Homebrew or the native package manager:

| Tool | Purpose |
| :--- | :--- |
| `git` | Version control (required by everything) |
| `stow` | Symlink manager (native fallback if missing) |
| `tmux` | Terminal multiplexer |
| `neovim` | Text editor |
| `fzf` | Fuzzy finder (used in Zsh, Telescope, Tmux) |
| `ripgrep` | Fast grep (required by Telescope live_grep) |
| `fd` | Fast `find` alternative |
| `zoxide` | Smart `cd` with frecency ranking |
| `bat` | `cat` with syntax highlighting (used in fzf previews) |
| `eza` | Modern `ls` with icons and tree view |
| `lazygit` | Terminal UI for git |
| `git-delta` | Side-by-side diff viewer for `git diff` / `git log` |

**Optional (macOS, `--casks`):**

| Tool | Purpose |
| :--- | :--- |
| `font-jetbrains-mono-nerd-font` | Nerd Font required by Kitty, Starship, Neovim icons |

---

## 🗑️ Uninstall

```bash
# Remove Neovim config and plugin data
rm -rf ~/.config/nvim ~/.local/share/nvim

# Remove all symlinks created by Stow (safe — leaves your real files untouched)
stow -D common        # un-stow base package
stow -D wayland-dms   # un-stow Wayland package (if installed)
stow -D x11-i3        # un-stow i3 package (if installed)
stow -D macos         # un-stow macOS package (if installed)
```

---

*Managed with ❤️ and [GNU Stow](https://www.gnu.org/software/stow/).*
