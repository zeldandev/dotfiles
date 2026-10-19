-- ─────────────────────────────────────────────────────────────────────────────
-- LAZY.NVIM BOOTSTRAP
-- lazy.nvim is the plugin manager. On the very first run (or if the directory
-- was deleted) it is not present yet, so we clone it from GitHub directly.
-- stdpath("data") resolves to ~/.local/share/nvim on Linux/macOS, so the
-- manager ends up at ~/.local/share/nvim/lazy/lazy.nvim.
-- "--filter=blob:none" makes the clone blobless (only downloads objects that
-- are actually needed), which is much faster than a full clone.
-- ─────────────────────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Prepend the lazy.nvim directory to the runtime path so that Neovim can
-- find and load it with a plain require("lazy") call.
vim.opt.rtp:prepend(lazypath)

-- ─────────────────────────────────────────────────────────────────────────────
-- SYSTEM-SPECIFIC RUNTIME PATHS
-- On some Linux distributions (e.g., Ubuntu/Debian) the Neovim package ships
-- compiled tree-sitter parsers in a multiarch library path that is NOT on the
-- default runtimepath. We probe the known locations and add any that exist so
-- that those system parsers are available alongside the ones managed by
-- nvim-treesitter itself.
-- ─────────────────────────────────────────────────────────────────────────────
local fs = vim.uv or vim.loop
local extra_rtp = {}
for _, p in ipairs({
  "/usr/lib/x86_64-linux-gnu/nvim",
  "/usr/lib/aarch64-linux-gnu/nvim",
}) do
  if fs.fs_stat(p) then
    table.insert(extra_rtp, p)
  end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LAZY SETUP
-- require("lazy").setup("plugins") tells lazy.nvim to auto-discover every
-- .lua file inside lua/plugins/ and treat each returned table as a plugin spec.
-- performance.rtp.reset = false prevents lazy from wiping the extra paths we
-- added above, and paths = extra_rtp appends them to the final runtime path
-- so they survive after lazy has finished reorganising the rtp.
-- ─────────────────────────────────────────────────────────────────────────────
require("lazy").setup("plugins", {
  performance = {
    rtp = {
      reset = false,    -- do not reset rtp to Neovim defaults; keep our custom additions
      paths = extra_rtp, -- inject the system-level multiarch nvim paths discovered above
    },
  },
})
