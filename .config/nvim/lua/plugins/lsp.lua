return {
  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Reference" }))
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }))
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.setloclist() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Show Diagnostics" }))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
          vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
          vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP References" }))
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
          vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
      end)

      require('mason').setup({
        lazy = false,
        config = true,
      })
      require('mason-lspconfig').setup({
        -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
        -- This setting has no relation with the `automatic_installation` setting.
        ensure_installed = {
          "lua_ls",
          "pylsp",
          "html",
          "jsonls",
          "docker_compose_language_service",
          "dockerls",
          "bashls",
          "tsserver",
          "eslint",
          "tailwindcss",
          "marksman",
          "gopls"
        },
        -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
        -- This setting has no relation with the `ensure_installed` setting.
        -- Can either be:
        --   - false: Servers are not automatically installed.
        --   - true: All servers set up via lspconfig are automatically installed.
        --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
        --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
        automatic_installation = true,
        handlers = {
          lsp_zero.default_setup,
        },
      })

      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
        })
      })

      lsp_zero.setup()
    end
  }

}
