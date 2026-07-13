-- File explorer
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })

    --Keymaps
    vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFileToggle<CR>", { desc = "NvimTree Find File" })
    vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>', { desc = "NvimTree Toggle" })
  end,
}
