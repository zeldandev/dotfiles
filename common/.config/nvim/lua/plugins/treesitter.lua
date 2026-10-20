return {
  {
    -- ─────────────────────────────────────────────────────────────────────────
    -- NVIM-TREESITTER — Syntax parsing and highlighting
    -- Tree-sitter is a parsing library that builds a concrete syntax tree (CST)
    -- for source files. Neovim uses this tree for:
    --   • Accurate syntax highlighting (much more precise than regex-based :syntax)
    --   • Indentation that understands code structure
    --   • Smart text objects (select inner function, inner block, etc.)
    --   • Many plugins (autopairs, autotag, refactoring, …) that need the AST
    --
    -- branch = "master" and build = ":TSUpdate" keep the parsers up to date
    -- whenever the plugin is updated. The plugin is loaded lazily on buffer
    -- open (BufReadPre / BufNewFile) to avoid slowing down startup.
    -- ─────────────────────────────────────────────────────────────────────────
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate", -- re-compile parsers after each plugin update
    dependencies = {
      -- nvim-ts-autotag uses the treesitter AST to close and rename HTML/JSX/Vue
      -- tags automatically as you type, without relying on fragile regex patterns.
      "windwp/nvim-ts-autotag",
    },
    opts = {
      -- Parsers to install automatically. Each entry corresponds to a language
      -- grammar that tree-sitter will compile and cache locally. Installing only
      -- the languages you use keeps disk usage and update time low.
      ensure_installed = {
        "lua",
        "go",
        "python",
        "c",
        "javascript",
        "dockerfile",
        "json",
        "yaml",
        "markdown",
        "markdown_inline", -- inline markdown (used inside fenced code blocks in markdown files)
        "html",
        "scss",
        "css",
        "vim",
        "vimdoc",          -- Neovim's built-in help file format
        "sql",
        "gitignore",
        "bash",
      },

      -- sync_install = false: parsers are compiled asynchronously in the
      -- background, so Neovim does not freeze on the very first startup when
      -- parsers need to be downloaded and compiled.
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      ts.install(opts.ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  }
}
