return {
  {
    -- Treesitter interface
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      -- A list of parser names, or "all"
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
        "markdown_inline",
        "html",
        "scss",
        "css",
        "vim",
        "vimdoc",
        "sql",
        "gitignore",
        "bash",
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      highlight = {
        enable = true, -- `false` will disable the whole extension
        use_languagetree = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      },
      autotag = {
        enable = true
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false
      },
      refactor = {
        highlight_definitions = {
          enable = true
        },
        highlight_current_scope = {
          enable = false
        }
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  }
}
