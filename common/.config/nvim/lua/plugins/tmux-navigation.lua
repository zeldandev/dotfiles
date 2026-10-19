-- ─────────────────────────────────────────────────────────────────────────────
-- VIM-TMUX-NAVIGATOR — Seamless Neovim ↔ tmux pane navigation
-- Allows moving between Neovim splits and tmux panes with the same keys
-- (<C-h/j/k/l>), so you do not need to remember whether the adjacent pane is
-- a Vim split or a tmux pane. The tmux side requires a matching configuration
-- in ~/.tmux.conf (smart-pane-switching bindings provided by the plugin README).
-- The plugin is loaded lazily: it activates only when one of the navigation
-- commands is executed or the mapped keys are pressed.
-- <C-U> in the command string clears any pending visual-mode count or range
-- before executing the navigation command, preventing accidental partial
-- command execution in command-line mode.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious", -- jump back to the previously active pane/split
  },
  keys = {
    { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },     -- move left  (Neovim split or tmux pane)
    { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },     -- move down
    { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },       -- move up
    { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },    -- move right
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" }, -- jump to the previously focused pane
  },
}
