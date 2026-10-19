-- ─────────────────────────────────────────────────────────────────────────────
-- CONFORM.NVIM — Code formatter runner
-- conform.nvim runs formatters on save (or on demand) without blocking the
-- editor. It supports running multiple formatters sequentially per file type,
-- falling back to the next one in the list if the first is not available.
-- The plugin is loaded lazily: it activates only when a buffer is opened
-- (BufReadPre for existing files, BufNewFile for new ones).
-- ─────────────────────────────────────────────────────────────────────────────
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        -- formatters_by_ft maps each file type to one or more formatter names.
        -- When a list is wrapped in a nested table with stop_after_first = true,
        -- conform tries each formatter in order and stops as soon as one succeeds.
        -- This allows "prettierd" (a daemon version of prettier that is faster
        -- after the first run) to be preferred while falling back to plain
        -- "prettier" if prettierd is not installed.
        formatters_by_ft = {
          lua = { "stylua" },                                                        -- Lua: opinionated formatter, respects .stylua.toml
          svelte = { { "prettierd", "prettier", stop_after_first = true } },         -- Svelte components
          astro = { { "prettierd", "prettier", stop_after_first = true } },          -- Astro framework files
          javascript = { { "prettierd", "prettier", stop_after_first = true } },     -- Plain JS
          typescript = { { "prettierd", "prettier", stop_after_first = true } },     -- Plain TS
          javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },-- JSX
          typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },-- TSX
          json = { { "prettierd", "prettier", stop_after_first = true } },           -- JSON / JSON5
          graphql = { { "prettierd", "prettier", stop_after_first = true } },        -- GraphQL schemas & queries
          java = { "google-java-format" },                                           -- Java: Google style guide formatter
          kotlin = { "ktlint" },                                                     -- Kotlin: official style linter/formatter
          ruby = { "standardrb" },                                                   -- Ruby: StandardRB enforces a single community style
          markdown = { { "prettierd", "prettier", stop_after_first = true } },       -- Markdown documents
          erb = { "htmlbeautifier" },                                                -- Rails ERB templates
          html = { "htmlbeautifier" },                                               -- Plain HTML
          bash = { "beautysh" },                                                     -- Bash scripts
          proto = { "buf" },                                                         -- Protocol Buffers (gRPC / proto3)
          rust = { "rustfmt" },                                                      -- Rust: built-in official formatter
          yaml = { "yamlfix" },                                                      -- YAML: preserves comments, fixes indentation
          toml = { "taplo" },                                                        -- TOML: Cargo.toml, pyproject.toml, etc.
          css = { { "prettierd", "prettier", stop_after_first = true } },            -- CSS
          scss = { { "prettierd", "prettier", stop_after_first = true } },           -- SCSS
          sh = { "shfmt" },                                                          -- POSIX shell scripts
          go = { "gofmt" },                                                          -- Go: standard formatter shipped with the Go toolchain
        },
      })

      -- <leader>l formats the current file (or the selected range in visual mode).
      -- lsp_format = "fallback" means: use the LSP formatter if conform does not
      -- have a formatter configured for the current file type. async = false
      -- blocks until formatting is done so the buffer is not saved with half-
      -- formatted content if auto-save is active.
      vim.keymap.set({ "n", "v" }, "<leader>l", function()
        conform.format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
}
