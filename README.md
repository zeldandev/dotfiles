# 🚀 Zeldan's Dotfiles

> A unified, high-performance, and keyboard-centric development environment for Linux and macOS.

![Linux](https://img.shields.io/badge/OS-Linux-blue?style=flat-square&logo=linux)
![macOS](https://img.shields.io/badge/OS-macOS-black?style=flat-square&logo=apple)
![Neovim](https://img.shields.io/badge/Editor-Neovim-green?style=flat-square&logo=neovim)
![Tmux](https://img.shields.io/badge/Multiplexer-Tmux-1E1E1E?style=flat-square&logo=tmux)
![Zsh](https://img.shields.io/badge/Shell-Zsh-orange?style=flat-square&logo=gnu-bash)

Welcome to my personal dotfiles. This repository contains the configuration files for my daily drivers, heavily optimized for productivity, modularity, and cross-platform consistency. The entire ecosystem is tightly integrated to provide an **IntelliJ-like** fluid experience directly from the terminal.

---

## 🌟 Key Features & Tools

- **💻 Window Managers:** `i3wm` with `Rofi` and `Polybar`.
- **📟 Terminal:** `Kitty` & `iTerm2`.
- **🐚 Shell (Zsh):** Highly customized with Vi-mode, `Starship` prompt, `zoxide` (smart cd), and `fzf` integration.
- **📝 Editor (Neovim):** Lua-based setup with native LSP, Telescope, and unified bindings.
- **🪟 Multiplexer (Tmux):** Configured with TPM, `tmux-resurrect`, and a beautiful Rosé Pine Moon theme.
- **🔗 Seamless Navigation:** Move between Neovim splits and Tmux panes flawlessly using `Ctrl + h/j/k/l` (`vim-tmux-navigator`).

## ⚙️ Installation

The installation process is fully automated, idempotent, and powered by **GNU Stow** to safely symlink files to your home directory.

### Prerequisites
Make sure you have `git` and `stow` installed on your system.

### Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/zeldandev/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Run the bootstrap script:**
   Depending on your operating system and desired environment, run one of the following commands:
   ```bash
   # Main Linux machine (Installs Common + DankMaterialShell)
   ./setup.sh --dms

   # Virtual Machine (Installs Common + i3/X11)
   ./setup.sh --i3

   # macOS (Automatically detected, installs Common + macOS specifics)
   ./setup.sh
   ```
   > **Note:** The script is intelligent. It will install Homebrew, initialize Git submodules (Zsh plugins, TPM), configure VSCodium, and symlink all files securely using `stow --restow <module>`.

3. **Install OS-specific apps:**
   Check the `misc/` folder for additional scripts to install missing packages on Debian-based systems or macOS.

## 🔧 Local Customization (Machine-Specific Settings)

These dotfiles support loading local, untracked configuration files per-machine. This allows you to define custom paths, API keys, aliases, or environment variables unique to a specific computer without modifying the Git repository.

To add machine-specific settings, simply create one or more of the following files in your `$HOME` directory:

| Local File | Purpose | Loaded By |
| --- | --- | --- |
| `~/.profile.local` | Custom user environment variables & generic system-wide settings | `~/.profile` (System Login) |
| `~/.zprofile.local` | Custom shell login initializations (e.g. machine-specific paths) | `~/.zprofile` (Zsh Login) |
| `~/.zshrc.local` | Custom interactive terminal configs, local aliases, or functions | `~/.zshrc` (Interactive Zsh) |

> 💡 **Note:** All `*.local` files are ignored by Git (configured in `.gitignore`), ensuring your personal API keys and local paths are never accidentally pushed to public repositories.

## ⌨️ Unified Keybindings

A major goal of these dotfiles is to maintain **keyboard consistency** across Neovim, IntelliJ (`IdeaVim`), Tmux, and the OS.

To quickly view the complete shortcut list while working:
- **In Tmux:** Press `Prefix + /` (`Ctrl+Space` then `/`) to spawn a floating cheatsheet.
- **In Neovim:** Press `<Space> + ?`
- **In Zsh:** Type `chuleta`
- **In i3 (Global):** Press `Super + c`

You can manually read the cheatsheet in [`cheatsheet.md`](cheatsheet.md).

## 📂 Repository Structure (Modular)

This repository uses **Stow Packages** to keep configs modular and clean across different OS and environments:

- **`common/`**: The base module installed everywhere (Neovim, Zsh, Tmux, Kitty).
- **`wayland-dms/`**: Wayland environment configs (DankMaterialShell).
- **`x11-i3/`**: X11 environment configs (i3, Polybar, Rofi, Picom) for VMs.
- **`macos/`**: macOS specific GUI apps (iTerm2).
- **`misc/`**: Helper scripts for OS-specific package installations.
- **`setup.sh`**: The core idempotent bootstrap script.

---
*Managed with ❤️ and GNU Stow.*
