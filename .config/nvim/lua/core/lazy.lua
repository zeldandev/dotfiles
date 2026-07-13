-- Ensure lazy.nvim package managet exits
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- add lazy.nvin to nvim path
vim.opt.rtp:prepend(lazypath)

-- Start lazy.nvim and configure plugins
require("lazy").setup(
  "plugins"
)
