# Neovim Configuration

A fast, modern Neovim setup built on **lazy.nvim** for on-demand plugin loading,
**LSP Zero** for language-server integration, and **Tree-sitter** for accurate
syntax highlighting. All configuration is written in Lua and lives under
`lua/core/` (editor settings & key mappings) and `lua/plugins/` (one file per
plugin).

---

## Requirements

| Dependency | Purpose |
| :--- | :--- |
| **Neovim ≥ 0.9** | Required (0.10+ recommended for native `vim.uv`) |
| **Git** | lazy.nvim bootstraps itself via `git clone` |
| **A [Nerd Font](https://www.nerdfonts.com/)** | Icons in the status bar, file tree, and completion menu |
| **[ripgrep](https://github.com/BurntSushi/ripgrep)** | Live grep in Telescope (`<leader>fs`) |
| **[mise](https://mise.jdx.dev/) / nvm / pyenv** | Runtime shims so Mason can find Node, Python, Go binaries |
| **Node.js** | Required by several LSP servers and markdown-preview |
| **make / gcc** | Compiles `telescope-fzf-native` for fast fuzzy sorting |

> [!TIP]
> On Ubuntu / Debian, Neovim ships tree-sitter parsers in a multiarch path
> (`/usr/lib/x86_64-linux-gnu/nvim`). The config detects and adds that path
> automatically so system parsers and plugin-managed parsers coexist.

---

## Installation

```bash
# Clone (or symlink from your dotfiles)
git clone https://github.com/youruser/dotfiles ~/.dotfiles
ln -sf ~/.dotfiles/common/.config/nvim ~/.config/nvim

# Open Neovim — lazy.nvim will install itself and all plugins on first launch
nvim
```

On first launch lazy.nvim bootstraps itself, downloads every plugin, and
Mason installs the configured language servers automatically.

### Reset / Remove

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim
```

---

## File Structure

```
nvim/
├── init.lua                  # Entry point — compatibility shims + loads core/
└── lua/
    ├── core/
    │   ├── init.lua          # Load order: options → lazy → keymaps
    │   ├── options.lua       # All vim.opt settings (leader, tabs, search, …)
    │   ├── keymap.lua        # Global key mappings not tied to a plugin
    │   └── lazy.lua          # lazy.nvim bootstrap & plugin manager setup
    └── plugins/
        ├── lsp.lua           # LSP Zero + Mason + nvim-cmp (autocompletion)
        ├── conform.lua       # Code formatters (prettier, stylua, gofmt, …)
        ├── treesitter.lua    # Syntax parsing & highlighting
        ├── telescope.lua     # Fuzzy finder
        ├── nvim-tree.lua     # File explorer sidebar
        ├── lualine.lua       # Status bar
        ├── colorscheme.lua   # Rose Pine (moon variant)
        ├── gitsigns.lua      # Git hunk signs in the gutter
        ├── neogit.lua        # Magit-style git interface
        ├── lazygit.lua       # LazyGit floating terminal
        ├── autopairs.lua     # Auto-close brackets & quotes
        ├── comment.lua       # gcc / gc comment toggling
        ├── which-key.lua     # Keymap popup helper
        ├── tmux-navigation.lua # Seamless Neovim ↔ tmux navigation
        └── markdown-preview.lua # Live browser preview for .md files
```

---

## Key Mappings

> **Leader key** → `Space`

### Editor & Window Management

| Key | Action |
| :--- | :--- |
| `<leader>sv` | Split window **vertically** |
| `<leader>sh` | Split window **horizontally** |
| `<C-h/j/k/l>` | Navigate splits **and** tmux panes seamlessly |
| `<C-n>` | Toggle **file tree** (nvim-tree) |
| `<leader>ef` | Open file tree **and highlight current file** |
| `<leader>?` | Open **cheat sheet** in a floating window |

### Telescope — Fuzzy Finder

| Key | Action |
| :--- | :--- |
| `<leader>ff` | Find files by name in cwd |
| `<leader>fs` | Live grep (search text across all files) |
| `<leader>fr` | Recent files |
| `<leader>fc` | Grep string under cursor |
| `<leader>fg` | Find git-tracked files |
| `<leader>fb` | Browse open buffers |
| `<leader>vh` | Search Neovim help tags |

### LSP

| Key | Mode | Action |
| :--- | :--- | :--- |
| `gd` | Normal | Go to **definition** |
| `gr` | Normal | Go to **references** |
| `K` | Normal | Hover **documentation** |
| `<leader>vrn` | Normal | **Rename** symbol |
| `<leader>vca` | Normal | **Code actions** |
| `<leader>vd` | Normal | Show **diagnostics** list |
| `[d` / `]d` | Normal | Previous / next **diagnostic** |
| `<leader>vws` | Normal | Workspace **symbol search** |
| `<C-h>` | Insert | **Signature help** |

### Completion (nvim-cmp)

| Key | Action |
| :--- | :--- |
| `<C-n>` / `<C-p>` | Select next / previous suggestion |
| `<C-Space>` | Manually trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Navigate suggestions or expand snippet |
| `<C-f>` / `<C-b>` | Jump forward / backward through snippet placeholders |
| `<C-u>` / `<C-d>` | Scroll documentation popup |

### Code Editing

| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>l` | Normal / Visual | **Format** file or selection |
| `gcc` | Normal | Toggle **line comment** |
| `gc` | Visual | Toggle **comment** on selection |
| `<Alt-j>` / `<Alt-k>` | Normal / Insert / Visual | **Move line(s)** down / up |
| `>` / `<` | Visual | Indent / de-indent (keeps selection) |
| `n` / `N` | Normal | Next / prev search result — **auto-centered** |
| `<Esc>` | Normal | **Clear** search highlight |

### Git

| Key | Action |
| :--- | :--- |
| `<leader>gg` | Open **LazyGit** in a floating terminal |
| `<leader>gs` | Open **Neogit** status buffer |
| `<leader>gc` | Neogit **commit** |
| `<leader>gp` | Neogit **pull** |
| `<leader>gP` | Neogit **push** |
| `<leader>gb` | Browse **branches** (Telescope) |
| `<leader>gB` | **Blame** current line (gitsigns) |

### Markdown

| Key | Action |
| :--- | :--- |
| `<leader>mp` | Toggle **markdown preview** in the browser |

---

## Plugins

| Plugin | Role |
| :--- | :--- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager with lazy-loading |
| [lsp-zero](https://github.com/VonHeikemen/lsp-zero.nvim) | LSP + completion glue layer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | In-editor LSP / DAP / linter installer |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between Mason and lspconfig |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatter runner |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax parsing & highlighting |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) | File explorer sidebar |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status bar |
| [rose-pine](https://github.com/rose-pine/neovim) | Color scheme (moon variant) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk indicators & blame |
| [neogit](https://github.com/NeogitOrg/neogit) | Magit-inspired git interface |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | LazyGit terminal integration |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets & quotes |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Code commenting (gcc / gc) |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap popup after leader |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless Neovim ↔ tmux navigation |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Live browser preview for Markdown |

---

## Language Servers (auto-installed by Mason)

`lua_ls` · `pylsp` · `ts_ls` · `eslint` · `html` · `jsonls` · `bashls` ·
`dockerls` · `docker_compose_language_service` · `tailwindcss` · `marksman` · `gopls`

## Formatters (via conform.nvim)

| Language(s) | Formatter |
| :--- | :--- |
| Lua | `stylua` |
| JS / TS / JSX / TSX / CSS / SCSS / JSON / GraphQL / Markdown / Svelte / Astro | `prettierd` → `prettier` |
| Go | `gofmt` |
| Rust | `rustfmt` |
| Python | LSP fallback (`pylsp`) |
| Java | `google-java-format` |
| Kotlin | `ktlint` |
| Ruby | `standardrb` |
| Bash / Shell | `beautysh` / `shfmt` |
| YAML | `yamlfix` |
| TOML | `taplo` |
| Protobuf | `buf` |
| HTML / ERB | `htmlbeautifier` |

> [!NOTE]
> Formatters are **not** installed by Mason automatically — install them
> with your system package manager, `npm`, `cargo`, `go install`, etc.
> mise shims are prepended to `PATH` so Mason and conform can find binaries
> managed by mise.
