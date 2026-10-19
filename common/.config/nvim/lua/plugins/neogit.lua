-- ─────────────────────────────────────────────────────────────────────────────
-- NEOGIT — Magit-inspired git interface
-- Neogit provides a full-featured, buffer-based git interface modelled after
-- Emacs' Magit. It covers staging individual hunks, writing commits, pulling,
-- pushing, managing branches, and viewing diffs — all from inside Neovim.
-- diffview.nvim adds a side-by-side diff viewer that Neogit opens for merge
-- conflicts and history inspection.
-- filewatcher.enabled = false disables the file-system watcher that Neogit
-- uses to auto-refresh its status buffer. The watcher can be unreliable on
-- some Linux setups (inotify limits) and causes high CPU on large repos, so
-- we disable it and rely on manual refresh (pressing "gr" inside Neogit).
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required: async utilities used throughout neogit
    "sindrets/diffview.nvim",         -- optional: rich diff viewer used for merge conflicts and history
    "nvim-telescope/telescope.nvim",  -- optional: used by neogit for branch/tag pickers
  },
  config = function()
    local neogit = require('neogit')
    neogit.setup({
      -- Disable the file system watcher to avoid inotify exhaustion on large
      -- repos and to prevent excessive CPU usage on network-mounted filesystems.
      filewatcher = { enabled = false }
    })

    -- Open the Neogit status buffer (equivalent to `git status` with a UI)
    vim.keymap.set('n', '<leader>gs', ':Neogit<CR>', { silent = true })

    -- Open the Neogit commit screen with a message buffer pre-focused
    vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>",
      { silent = true, noremap = true }
    )

    -- Pull from the remote (Neogit will prompt for remote/branch if needed)
    vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>",
      { silent = true, noremap = true }
    )

    -- Push the current branch to the remote (uppercase P to distinguish from pull)
    vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>",
      { silent = true, noremap = true }
    )

    -- Browse and switch git branches using Telescope's fuzzy finder
    vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>",
      { silent = true, noremap = true }
    )

    -- Show git blame for the current line using gitsigns' inline annotation.
    -- Uppercase B to distinguish from <leader>gb (branch picker) above.
    vim.keymap.set("n", "<leader>gB", ":Gitsigns blame_line<CR>",
      { silent = true, noremap = true, desc = "Git blame line" }
    )
  end,
}
