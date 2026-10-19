-- ─────────────────────────────────────────────────────────────────────────────
-- LUALINE — Status bar
-- lualine renders a fast, highly customisable status line at the bottom of
-- each window (and optionally a winbar at the top). It replaces Neovim's
-- default plain-text statusline with a styled bar that shows the current
-- mode, git branch, diff stats, LSP diagnostics, file name, encoding,
-- file format, file type, scroll position, and cursor location.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- file type icons in the status bar
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,  -- show file type and component icons (requires a Nerd Font)
          theme = 'auto',        -- pick the lualine theme that matches the active colorscheme

          -- Powerline-style separators between components within the same section.
          -- Use '' / '' for the angled arrow style, or '|' / '|' for plain text.
          component_separators = { left = '', right = '' },

          -- Powerline-style separators between the left, middle, and right sections.
          section_separators = { left = '', right = '' },

          -- Disable the status line (and winbar) for specific file types to avoid
          -- clutter in helper windows. NvimTree already has its own UI.
          disabled_filetypes = {
            statusline = {},
            winbar = { "help", "NvimTree" },
          },

          ignore_focus = {},        -- (empty) do not suppress lualine in any focused window

          -- always_divide_middle = true keeps the lualine_c and lualine_x sections
          -- separated even when one of them is empty, ensuring the layout is stable.
          always_divide_middle = true,

          -- globalstatus = false: each window gets its own status line instead of
          -- sharing a single global one. This makes it easy to see which split is
          -- active because only the focused window's status line is fully lit.
          globalstatus = false,

          -- How often (in milliseconds) each section is refreshed. 1000 ms means
          -- the status bar updates roughly once per second, which is fast enough
          -- for diagnostics and git info without causing unnecessary redraws.
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },

        -- ─────────────────────────────────────────────────────────────────
        -- ACTIVE WINDOW SECTIONS
        -- lualine divides the status bar into six sections (a–z), three on
        -- the left and three on the right.
        -- ─────────────────────────────────────────────────────────────────
        sections = {
          lualine_a = { 'mode' },                           -- current Vim mode (NORMAL, INSERT, …)
          lualine_b = { 'branch', 'diff', 'diagnostics' },  -- git branch, +/-/~ diff counts, LSP diagnostic counts
          lualine_c = { 'filename' },                        -- relative file path of the current buffer
          lualine_x = { 'encoding', 'fileformat', 'filetype' }, -- UTF-8 / LF|CRLF / language
          lualine_y = { 'progress' },                        -- percentage through the file
          lualine_z = { 'location' }                         -- line:column cursor position
        },

        -- ─────────────────────────────────────────────────────────────────
        -- INACTIVE WINDOW SECTIONS
        -- Shown in splits that do not have focus. Kept minimal to avoid
        -- visual noise when many splits are open simultaneously.
        -- ─────────────────────────────────────────────────────────────────
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' }, -- still show the file name so you know what each split contains
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },

        tabline = {},  -- no tabline (use bufferline or native tabs if needed)
        winbar = {},   -- no winbar above each window (disabled for all file types above)

        -- Register extensions so lualine shows a simplified status bar when
        -- these special windows are focused instead of the default sections.
        extensions = { "lazy", "nvim-tree", "quickfix" },
      })
    end
  }
}
