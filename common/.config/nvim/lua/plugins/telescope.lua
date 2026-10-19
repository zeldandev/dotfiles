-- ─────────────────────────────────────────────────────────────────────────────
-- TELESCOPE — Fuzzy finder
-- Telescope is a highly extensible fuzzy-finder that can search files, grep
-- text, browse git history, list LSP symbols, and much more. It uses plenary
-- for async utilities and telescope-fzf-native for a C-compiled FZF sorter
-- that is significantly faster than the default Lua sorter on large repos.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", {
      -- fzf-native must be compiled with `make` during installation. It replaces
      -- Telescope's default sorter with a native C implementation of FZF's
      -- fuzzy-matching algorithm, making searches near-instant even in repos
      -- with hundreds of thousands of files.
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    } },
    config = function(_)
      require("telescope").setup({
        defaults = {
          -- Directories and patterns to exclude from all Telescope pickers.
          -- node_modules and .git can contain millions of files and are almost
          -- never what you want when searching project source code.
          file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/" },
        },
      })

      -- Load the fzf extension AFTER setup() so that Telescope registers it
      -- and uses the native sorter for all subsequent picker invocations.
      require("telescope").load_extension("fzf")

      -- ─────────────────────────────────────────────────────────────────────
      -- TELESCOPE KEYMAPS
      -- All mappings use <leader>f as a common prefix ("find"), making them
      -- easy to discover through which-key.
      -- ─────────────────────────────────────────────────────────────────────

      -- Find files by name in the current working directory (respects .gitignore)
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>', { desc = "Fuzzy find files in cwd" })

      -- Browse recently opened files (persisted across Neovim sessions)
      vim.keymap.set('n', '<leader>fr', ':Telescope oldfiles<cr>', { desc = "Fuzzy find recent files" })

      -- Live grep: search for a string across all files in the cwd using ripgrep
      vim.keymap.set('n', '<leader>fs', ':Telescope live_grep<cr>', { desc = "Find string in cwd" })

      -- Grep for the exact word under the cursor across the whole project
      vim.keymap.set('n', '<leader>fc', ':Telescope grep_string<cr>', { desc = "Find string under cursor in cwd" })

      -- Find files tracked by git (respects the git index, faster than find_files in git repos)
      vim.keymap.set('n', '<leader>fg', ':Telescope git_files<cr>', { desc = "Find git files in cwd" })

      -- Search Neovim's built-in help tags — useful for quickly looking up options or functions
      vim.keymap.set('n', '<leader>vh', ':Telescope help_tags<cr>', { desc = "Find help tags" })

      -- List all currently open buffers and fuzzy-search among them
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>', { desc = "Find open buffers" })
    end
  }
}
