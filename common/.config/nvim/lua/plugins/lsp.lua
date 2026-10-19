-- ─────────────────────────────────────────────────────────────────────────────
-- LSP ZERO + MASON + nvim-cmp
-- lsp-zero is a convenience layer that wires together:
--   • nvim-lspconfig  – the official collection of LSP server configurations
--   • mason           – GUI installer for LSP servers, DAP adapters, linters, and formatters
--   • mason-lspconfig – bridge between mason and lspconfig so installed servers
--                       are automatically configured by lspconfig
--   • nvim-cmp        – completion engine that shows suggestions from the LSP,
--                       snippets, and other sources
--   • LuaSnip         – snippet engine required by nvim-cmp
-- ─────────────────────────────────────────────────────────────────────────────
return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- Core LSP configuration library — provides a sane default setup for
      -- each language server so we only need to list server names.
      { 'neovim/nvim-lspconfig' },             -- Required

      -- Mason: in-editor installer UI (:Mason) that downloads language servers,
      -- linters, formatters, and DAP adapters from the internet.
      { 'williamboman/mason.nvim' },           -- Optional

      -- Bridge: translates mason-installed server names into the names that
      -- nvim-lspconfig understands and auto-calls lspconfig.setup() for each.
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Completion engine: shows a pop-up menu of suggestions as you type.
      { 'hrsh7th/nvim-cmp' },     -- Required

      -- Completion source: feeds LSP completion items into nvim-cmp.
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required

      -- Snippet engine + a large community snippet library. LuaSnip drives the
      -- Tab-to-expand and Tab-to-jump-between-placeholders behaviour inside
      -- the completion pop-up.
      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      -- Load VSCode-style snippets from friendly-snippets lazily so they are
      -- available in the completion menu without slowing down startup.
      require('luasnip.loaders.from_vscode').lazy_load()

      -- on_attach runs once every time an LSP server attaches to a buffer.
      -- All buffer-local LSP keymaps are defined here so they only exist in
      -- buffers where a language server is actually active.
      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        -- Jump to all references of the symbol under the cursor
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Reference" }))

        -- Jump to the definition of the symbol under the cursor
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }))

        -- Show documentation for the symbol under the cursor in a floating window
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))

        -- Search for a symbol across the entire workspace (project-wide)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }))

        -- Populate the location list with all diagnostics for the current buffer
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.setloclist() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Show Diagnostics" }))

        -- Navigate to the previous diagnostic (error / warning / hint) in the buffer
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
          vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))

        -- Navigate to the next diagnostic in the buffer
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
          vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))

        -- Show available code actions at the cursor position (quick-fixes, refactors, …)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))

        -- Show all references of the symbol under the cursor (same as gr, kept as alias)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP References" }))

        -- Rename the symbol under the cursor across the entire project
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))

        -- Show function signature help in insert mode (useful inside function call arguments)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
      end)

      -- ───────────────────────────────────────────────────────────────────────
      -- MASON SETUP
      -- Initialise mason with default settings. After this call the :Mason UI
      -- command is available to browse, install, and update servers/tools.
      -- ───────────────────────────────────────────────────────────────────────
      require('mason').setup()

      require('mason-lspconfig').setup({
        -- Servers listed here will be installed automatically the first time
        -- Neovim starts if they are not already present. This covers the full
        -- set of languages used day-to-day: Lua, Python, HTML/CSS, JSON,
        -- Docker, Bash, TypeScript/ESLint, Tailwind, Markdown, and Go.
        -- This setting has no relation with the `automatic_installation` setting.
        ensure_installed = {
          "lua_ls",
          "pylsp",
          "html",
          "jsonls",
          "docker_compose_language_service",
          "dockerls",
          "bashls",
          "ts_ls",
          "eslint",
          "tailwindcss",
          "marksman",
          "gopls"
        },
        -- When true, any server that is configured via lspconfig (e.g., because
        -- it was set up manually or by a plugin) is also automatically installed
        -- through mason if it is not already present. This catches servers that
        -- are not in ensure_installed but are still needed.
        -- This setting has no relation with the `ensure_installed` setting.
        -- Can either be:
        --   - false: Servers are not automatically installed.
        --   - true: All servers set up via lspconfig are automatically installed.
        --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
        --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
        automatic_installation = true,
        handlers = {
          -- Use lsp-zero's default_setup handler, which calls lspconfig[server].setup()
          -- with sensible defaults and adds the nvim-cmp capabilities automatically.
          lsp_zero.default_setup,
        },
      })

      -- ───────────────────────────────────────────────────────────────────────
      -- COMPLETION (nvim-cmp) SETUP
      -- extend_cmp must be called before cmp.setup() so that lsp-zero can
      -- inject its formatting and LSP capability enhancements into cmp.
      -- ───────────────────────────────────────────────────────────────────────
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      -- cmp_select specifies that moving through the menu highlights the item
      -- but does NOT insert it until <CR> or another confirm key is pressed.
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        -- Use lsp-zero's built-in formatting for completion items (shows icons
        -- for the kind of completion: function, variable, snippet, etc.).
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select), -- select previous suggestion
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select), -- select next suggestion
          ['<C-Space>'] = cmp.mapping.complete(),               -- manually trigger completion
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),              -- scroll documentation up
          ['<C-d>'] = cmp.mapping.scroll_docs(4),               -- scroll documentation down
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),        -- jump to next snippet placeholder
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),       -- jump to previous snippet placeholder
          ['<CR>'] = cmp.mapping.confirm({ select = true }),     -- confirm selected item (or first if none selected)
          ["<Tab>"] = cmp_action.luasnip_supertab(),            -- Tab: expand snippet or select next item
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),    -- Shift-Tab: select previous item
        })
      })
    end
  }

}
