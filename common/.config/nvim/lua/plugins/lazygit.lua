-- ─────────────────────────────────────────────────────────────────────────────
-- LAZYGIT.NVIM — LazyGit integration
-- Opens a full LazyGit terminal UI inside a floating Neovim window, giving
-- access to staging, committing, branching, rebasing, and cherry-picking
-- without leaving the editor. LazyGit itself must be installed separately
-- (e.g., `brew install lazygit` or via your system package manager).
-- The plugin is loaded lazily: it activates only when one of the listed
-- commands is executed or the keymap is pressed, so it adds zero cost to
-- normal startup time.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",                  -- open the main LazyGit interface
    "LazyGitConfig",            -- open LazyGit's own configuration file
    "LazyGitCurrentFile",       -- open LazyGit scoped to the current file's repository
    "LazyGitFilter",            -- open the commit log filtered by a pattern
    "LazyGitFilterCurrentFile", -- open the commit log filtered to the current file
  },
  dependencies = {
    -- plenary.nvim is a Lua utility library used by lazygit.nvim for async
    -- terminal handling and window management.
    "nvim-lua/plenary.nvim",
  },
  -- Use the `keys` spec (instead of vim.keymap.set) so lazy.nvim can load
  -- the plugin on-demand the first time the keymap is pressed.
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }, -- open LazyGit with <leader>gg
  },
}
