-- ─────────────────────────────────────────────────────────────────────────────
-- ROSE-PINE — Color scheme
-- Rose Pine is a dark, muted color scheme with warm tones. We use the "moon"
-- variant, which has a slightly cooler background than the default "main"
-- variant and is easier on the eyes during long coding sessions.
-- priority = 1000 ensures this plugin is loaded before any other plugin that
-- may try to set or override highlight groups, preventing flash-of-wrong-colors
-- on startup. lazy = false forces it to load at startup rather than on demand.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000, -- load before all other plugins to avoid color flickering on startup
    config = function()
      require("rose-pine").setup({
        -- "moon" is the softer, cooler variant of rose-pine. The other options
        -- are "main" (warmer, higher contrast) and "dawn" (light background).
        variant = "moon",
        dark_variant = "moon", -- used when background is set to "dark"
        styles = {
          bold = true,         -- enable bold for keywords, function names, etc.
          italic = true,       -- enable italics for comments and certain constructs
          transparency = false -- disable transparent background (use the theme's solid color)
        },
      })
      -- Apply the color scheme. This must be called after setup() so that all
      -- the customisations above are taken into account.
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
