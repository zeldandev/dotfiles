-- ─────────────────────────────────────────────────────────────────────────────
-- GITSIGNS — Git hunk indicators in the sign column
-- gitsigns decorates every line that has been added, modified, or deleted
-- compared to the git index (HEAD). The indicators appear in the sign column
-- (the narrow strip to the left of line numbers) so they are visible at a
-- glance without taking up buffer space. It also provides hunk-aware commands
-- for staging, resetting, previewing, and navigating hunks without leaving
-- Neovim, and it integrates with lualine to show the diff summary in the
-- status bar.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,
}
