-- ─────────────────────────────────────────────────────────────────────────────
-- WHICH-KEY — Keybinding popup helper
-- which-key shows a popup menu after you press the leader key (or any prefix)
-- and pause for a moment. The menu lists all keybindings that start with that
-- prefix along with their descriptions, so you can discover and remember
-- mappings without consulting external documentation.
-- event = "VeryLazy" defers loading until after the UI is fully ready so it
-- does not add to startup time. The delay (in milliseconds) controls how long
-- you have to hold the prefix before the popup appears — 300 ms is responsive
-- without being intrusive.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Wait 300 ms after the last key press before showing the popup.
    -- Lower values make the popup appear faster but can feel distracting
    -- during fast typing; higher values are less intrusive but may feel slow.
    delay = 300,
  },
}
