-- Plugin to have a menu to find files
return {
  {
    -- Telescope
    -- Find, Filter, Preview, Pick. All lua, all the time.
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    } },
    config = function(_)
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/" },
        },
      })
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("fzf")

      -- telescope keymaps
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>', { desc = "Fuzzy find files in cwd" })
      vim.keymap.set('n', '<leader>fr', ':Telescope oldfiles<cr>', { desc = "Fuzzy find recent files" })
      vim.keymap.set('n', '<leader>fs', ':Telescope live_grep<cr>', { desc = "Find string in cwd" })
      vim.keymap.set('n', '<leader>fc', ':Telescope grep_string<cr>', { desc = "Find string under cursor in cwd" })
      vim.keymap.set('n', '<leader>fg', ':Telescope git_files<cr>', { desc = "Find git files in cwd" })
      vim.keymap.set('n', '<leader>vh', ':Telescope help_tags<cr>', { desc = "Find help tags" })
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>', { desc = "Find open buffers" })
    end
  }
}
