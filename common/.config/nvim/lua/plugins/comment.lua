-- ─────────────────────────────────────────────────────────────────────────────
-- COMMENT.NVIM — Easy code commenting
-- Provides two main operations driven by gcc / gbc (and their visual-mode
-- equivalents gc / gb):
--   • gcc — toggle line comment on the current line (or N lines with a count)
--   • gbc — toggle block comment around the current line
--   • gc<motion> — comment the region covered by a motion (e.g., gc5j)
--   • gc in visual mode — comment the selected lines
-- The plugin is treesitter-aware and automatically uses the correct comment
-- syntax for embedded languages (e.g., CSS inside a <style> block in HTML).
-- lazy = false ensures the keymaps are available from the very first buffer.
-- ─────────────────────────────────────────────────────────────────────────────
return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- No customisation needed; the defaults cover all common use cases.
      -- See :help comment-nvim for available options such as custom mappings,
      -- padding, sticky cursor, and per-filetype comment string overrides.
    },
    lazy = false,
  }
}
