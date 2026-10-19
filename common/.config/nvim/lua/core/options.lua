-- ─────────────────────────────────────────────────────────────────────────────
-- LEADER KEY
-- The leader key is the prefix used for most custom mappings. Setting it to
-- Space keeps it easy to reach and is the de-facto standard in modern configs.
-- This assignment MUST happen before lazy.nvim loads any plugin, because some
-- plugins read vim.g.mapleader at load time to register their own mappings.
-- ─────────────────────────────────────────────────────────────────────────────
vim.g.mapleader = " "

-- ─────────────────────────────────────────────────────────────────────────────
-- DISABLE NETRW
-- netrw is Neovim's built-in file explorer and remote-file handler. We replace
-- it completely with nvim-tree, so it must be disabled before any plugin is
-- loaded; otherwise netrw may hijack directory-open events and interfere with
-- nvim-tree's "hijack_netrw" option.
-- ─────────────────────────────────────────────────────────────────────────────
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_dir = 1

-- ─────────────────────────────────────────────────────────────────────────────
-- LINE NUMBERS
-- relativenumber shows the distance (in lines) from the cursor so that vertical
-- motions like "5j" or "d8k" can be typed without counting. The combination
-- with number = true makes the current line display its real file-line number
-- while all other lines show relative offsets.
-- scrolloff = 8 keeps at least 8 lines visible above and below the cursor so
-- context is never completely hidden when scrolling near the top/bottom.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number = true         -- shows absolute line number on cursor line (when relative number is on)
vim.opt.scrolloff = 8         -- always keep 8 lines of context around the cursor

-- ─────────────────────────────────────────────────────────────────────────────
-- TABS & INDENTATION
-- Using spaces (not real tab characters) with a width of 2 matches the default
-- style expected by Prettier, ESLint, and most JS/TS/Lua projects. autoindent
-- copies the leading whitespace of the current line when you press Enter, so
-- you don't have to re-indent manually on every new line.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2    -- 2 spaces for indent width
vim.opt.expandtab = true  -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- ─────────────────────────────────────────────────────────────────────────────
-- LINE WRAPPING
-- Disabling wrap keeps long lines on a single screen row. Combined with
-- horizontal scrolling this avoids the visual confusion of wrapped text
-- breaking up code structure.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.wrap = false -- disable line wrapping

-- ─────────────────────────────────────────────────────────────────────────────
-- SEARCH SETTINGS
-- ignorecase makes searches case-insensitive by default.
-- smartcase overrides that: if the search pattern contains any uppercase letter
-- Neovim treats the whole pattern as case-sensitive, which is the most ergonomic
-- behaviour. hlsearch highlights every match in the buffer so you can see them
-- all at once; incsearch updates highlights incrementally while you are still
-- typing the pattern.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.hlsearch = true   -- highlight all occurrences of the search pattern
vim.opt.incsearch = true  -- highlight incrementally while typing the search pattern

-- ─────────────────────────────────────────────────────────────────────────────
-- CURSOR LINE
-- Highlights the entire line the cursor is on with a subtle background colour.
-- This makes it much easier to track the cursor's position when the file is
-- long or when switching back to the window after looking away.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.cursorline = true -- highlight the current cursor line

-- ─────────────────────────────────────────────────────────────────────────────
-- APPEARANCE
-- termguicolors tells Neovim to use 24-bit RGB colours instead of the limited
-- 256-colour palette. This is required by virtually every modern colour scheme,
-- including rose-pine, and depends on the terminal emulator supporting true
-- colour (most modern ones do: iTerm2, Alacritty, Kitty, WezTerm, …).
-- background = "dark" is a hint to colour schemes that can work in both light
-- and dark mode — they will choose the dark variant.
-- signcolumn = "yes" reserves a fixed-width column on the left edge of every
-- window for signs (LSP diagnostics, git hunks from gitsigns, breakpoints, …).
-- Keeping it always visible prevents the text from jumping left/right as signs
-- appear and disappear.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- ─────────────────────────────────────────────────────────────────────────────
-- BACKSPACE BEHAVIOUR
-- By default Vim's backspace is restricted and cannot delete past autoindent,
-- end-of-line, or the position where Insert mode was started. Setting these
-- three values restores the intuitive behaviour you would expect in any editor.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- ─────────────────────────────────────────────────────────────────────────────
-- CLIPBOARD
-- "unnamedplus" maps Neovim's default register to the system clipboard (X11
-- CLIPBOARD selection / macOS pasteboard). This means that y/d/p operations
-- work seamlessly with Ctrl+C / Ctrl+V outside Neovim without needing a +
-- prefix on every yank command.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- ─────────────────────────────────────────────────────────────────────────────
-- SPLIT WINDOWS
-- By default Neovim opens vertical splits to the left and horizontal splits
-- above. These options flip that to the more natural "new window appears
-- to the right / below" behaviour used by most IDEs.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- ─────────────────────────────────────────────────────────────────────────────
-- SWAP FILE
-- Neovim creates .swp files as a crash-recovery mechanism. Disabling them
-- keeps the working directory clean. Modern workflows using version control
-- (git) make swap files largely redundant for recovery purposes.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.swapfile = false

-- Ensure all files are read and written as UTF-8, which is the universal
-- encoding for source code and avoids mojibake when working across different
-- systems or sharing files via git.
vim.opt.encoding = "utf-8"

-- ─────────────────────────────────────────────────────────────────────────────
-- MOUSE SUPPORT
-- Enabling mouse mode ("a" = all modes) allows click-to-position, scroll, and
-- drag-to-resize splits. Useful mainly for adjusting split sizes visually or
-- for pair-programming sessions where the other person is not a Vim user.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.mouse = 'a'

-- ─────────────────────────────────────────────────────────────────────────────
-- MODE DISPLAY
-- Hides the "--INSERT--" / "--VISUAL--" text at the bottom of the screen
-- because lualine already shows the current mode in the status bar with better
-- styling. Showing it in two places would be redundant and waste screen space.
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.showmode = false

-- ─────────────────────────────────────────────────────────────────────────────
-- MISE SHIMS IN PATH
-- mise (formerly rtx) is a polyglot runtime version manager. It installs
-- runtimes (Node, Python, Go, …) under ~/.local/share/mise and exposes thin
-- shim executables in its shims directory. Mason (the LSP/DAP/linter
-- installer) and conform (the formatter runner) rely on those executables
-- being on PATH. We prepend the shims dir only when it exists and is not
-- already present, so we don't accumulate duplicate entries on repeated
-- sourcing or nested Neovim sessions.
-- ─────────────────────────────────────────────────────────────────────────────
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 and not string.find(vim.env.PATH, mise_shims, 1, true) then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end
