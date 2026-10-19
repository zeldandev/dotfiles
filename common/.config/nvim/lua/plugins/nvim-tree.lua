-- ─────────────────────────────────────────────────────────────────────────────
-- NVIM-TREE — File explorer sidebar
-- nvim-tree replaces Neovim's built-in netrw with a proper tree-style file
-- explorer. netrw must be disabled in options.lua BEFORE this plugin loads
-- (via vim.g.loaded_netrw = 1 and vim.g.loaded_netrwPlugin = 1) so that
-- nvim-tree can register as the sole directory handler.
-- lazy = false forces this plugin to load at startup rather than on demand,
-- because the tree needs to be available immediately when Neovim opens a
-- directory or when the user presses the toggle key.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- file type icons in the tree
  config = function()
    local nvimtree = require("nvim-tree")

    nvimtree.setup({
      -- hijack_netrw = true: intercept any attempt to open a directory (e.g., `nvim .`)
      -- and open nvim-tree instead of netrw's default directory view.
      hijack_netrw = true,
      actions = {
        open_file = {
          -- Close the tree automatically after opening a file so it does not
          -- keep taking up screen space once you have navigated to your target.
          quit_on_open = true,
        },
      },
    })

    -- <leader>ef — "explore find": open the tree AND focus the currently open file
    -- inside it, so you can immediately see where you are in the project structure.
    vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFileToggle<CR>", { desc = "NvimTree Find File" })

    -- <C-n> — quick toggle: show or hide the tree without moving focus away from
    -- the current buffer. The same key closes it if it is already open.
    vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>', { desc = "NvimTree Toggle" })
  end,
}
