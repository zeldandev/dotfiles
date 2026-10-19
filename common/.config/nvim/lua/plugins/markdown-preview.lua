-- ─────────────────────────────────────────────────────────────────────────────
-- MARKDOWN-PREVIEW.NVIM — Live browser preview for Markdown files
-- Opens a browser tab that renders the current Markdown buffer in real time as
-- you edit. The preview syncs the scroll position with the cursor so you always
-- see the rendered output of the section you are working on.
-- The plugin is loaded lazily in two ways:
--   • cmd = { … } — activates on the first use of any of the listed commands
--   • ft = { "markdown" } — activates only in Markdown buffers, so the plugin
--     is never loaded when editing other file types
-- The build function runs the Node.js install script that compiles the preview
-- server; it is executed once after the plugin is installed or updated.
-- The keymap (<leader>mp) is defined in core/keymap.lua and calls
-- :MarkdownPreviewToggle to open or close the browser tab.
-- ─────────────────────────────────────────────────────────────────────────────
return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
}
