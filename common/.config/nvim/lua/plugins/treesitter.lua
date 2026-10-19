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
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
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
      sync_install = false,

      highlight = {
        -- Enable tree-sitter based highlighting. Setting this to false would
        -- fall back to Vim's legacy regex-based :syntax highlighting.
        enable = true,

        -- additional_vim_regex_highlighting = false: do NOT run the old regex
        -- highlighter alongside tree-sitter. Running both is redundant, can
        -- cause visual inconsistencies (duplicate or conflicting highlights),
        -- and slows down rendering.
        additional_vim_regex_highlighting = false,
      },

      indent = {
        -- Use tree-sitter's understanding of the code structure to determine
        -- the correct indentation level when pressing Enter or re-indenting
        -- with == / gg=G. More accurate than Vim's built-in cindent/smartindent.
        enable = true,
      },

      autotag = {
        -- Enable the nvim-ts-autotag integration. When you rename an opening
        -- HTML/JSX tag, the matching closing tag is renamed automatically.
        -- When you type ">", the closing tag is inserted immediately after.
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }
}
