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

-- Neovim generates its help tags before lazy.nvim loads plugins. Keep the
-- parsers managed by nvim-treesitter visible during that early phase too.
local treesitter_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
if (vim.uv or vim.loop).fs_stat(treesitter_path) then
  vim.opt.rtp:append(treesitter_path)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LAZY SETUP
-- require("lazy").setup("plugins") tells lazy.nvim to auto-discover every
-- .lua file inside lua/plugins/ and treat each returned table as a plugin spec.
-- ─────────────────────────────────────────────────────────────────────────────
require("lazy").setup("plugins", {
  performance = {
    rtp = {
      reset = false,
    },
  },
})
