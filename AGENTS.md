# Repository Guidelines

## Project Structure & Module Organization

This repository manages cross-platform development environments rather than a conventional application. `common/` contains configuration installed on every machine, including Zsh, Neovim, Tmux, Kitty, Starship, and editor settings. `wayland-dms/`, `x11-i3/`, and `macos/` hold platform-specific GNU Stow packages. `misc/` contains OS setup scripts and supporting documentation; `Brewfile` and `Brewfile.cask` declare Homebrew dependencies. `setup.sh` is the main idempotent bootstrap script, while `cheatsheet.md` documents shared keybindings. Keep machine-specific secrets in ignored files such as `~/.zshrc.local`, never in tracked configuration.

## Build, Test, and Development Commands

There is no compiled build or formal test suite. Use these commands when developing:

- `./setup.sh --common` — install base dependencies and link common configuration.
- `./setup.sh --dms`, `./setup.sh --i3`, or `./setup.sh --wsl` — exercise the corresponding Linux setup path.
- `./setup.sh --no-brew` — test native package-manager behavior without Homebrew.
- `bash -n setup.sh` — check shell syntax without making changes.
- `git submodule update --init --recursive` — initialize configuration submodules when needed.

Run setup commands in a disposable or well-understood environment: they can install packages and create or replace symlinks (backups are created for conflicts).

## Coding Style & Naming Conventions

Use two-space indentation for shell scripts, Bash-compatible syntax, quoted variable expansions, and descriptive lower-case function names with underscores (for example, `install_native_dependencies`). Preserve executable permissions on scripts. Follow existing configuration conventions: Lua modules use lower-case descriptive filenames; shell fragments use names such as `aliasrc`, `envrc`, and `pathrc`; platform directories use lower-case names. Keep comments focused on non-obvious behavior.

## Testing Guidelines

For shell changes, run `bash -n` and manually exercise the affected `setup.sh` flag. Validate symlink targets and inspect `git diff` afterward. For Neovim or Tmux changes, launch the relevant program and verify startup plus the affected keybinding/plugin behavior. No coverage threshold is currently defined.

## Commit & Pull Request Guidelines

Use concise imperative commit subjects with an optional category prefix, matching history such as `fix: update nvim configuration` or `update vscode config`. Keep commits focused. Pull requests should explain the platform(s) affected, list validation commands performed, call out package or startup changes, and include screenshots or terminal output when modifying visual desktop configuration. Never include credentials, tokens, or personal machine paths.
