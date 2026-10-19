-- ─────────────────────────────────────────────────────────────────────────────
-- NVIM-AUTOPAIRS — Automatic bracket / quote pairing
-- Inserts the matching closing character whenever you type an opening one
-- (e.g., typing "(" automatically adds ")" after the cursor). The plugin is
-- treesitter-aware: it inspects the AST node under the cursor and skips
-- auto-pairing in string or comment nodes where it would usually be unwanted.
-- It integrates with nvim-cmp so that when you confirm a completion item that
-- ends with a function call the closing parenthesis is inserted correctly.
-- The plugin is loaded lazily: it only activates when Insert mode is first
-- entered (event = "InsertEnter").
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    -- nvim-cmp must be loaded first because we hook into its "confirm_done"
    -- event to insert the closing pair after a completion item is selected.
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      -- check_ts = true: use the tree-sitter syntax tree to decide whether
      -- auto-pairing should be suppressed at the current cursor position.
      check_ts = true,
      ts_config = {
        -- In Lua, do not insert pairs inside string nodes (avoids doubling
        -- quotes inside already-quoted strings).
        lua = { "string" },
        -- In JavaScript, do not insert pairs inside template_string nodes
        -- (backtick template literals already handle their own interpolation).
        javascript = { "template_string" },
        -- Disable tree-sitter checks for Java entirely because the Java
        -- parser is slower and the gains are minimal.
        java = false,
      },
    })

    -- Hook autopairs into nvim-cmp's confirm_done event. Without this, when
    -- you accept a completion item for a function, the closing ")" is NOT
    -- inserted by autopairs (because the pair was already opened by the
    -- completion item itself). This event handler ensures the pair is always
    -- balanced after a completion.
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
