-- Compatibility polyfills for Neovim < 0.10
-- vim.uv is the new name for the libuv bindings previously exposed as vim.loop.
-- Older builds only have vim.loop, so we alias it so the rest of the config can
-- always use the modern vim.uv name without version-checking everywhere else.
if not vim.uv then
  vim.uv = vim.loop
end

-- vim.fs.joinpath was added in Neovim 0.10. On older versions we provide a
-- minimal fallback that joins path segments with "/" and collapses any
-- accidental double-slashes that may appear in the result.
if not vim.fs.joinpath then
  vim.fs.joinpath = function(...)
    return (table.concat({ ... }, "/"):gsub("//+", "/"))
  end
end

-- Bootstrap the rest of the configuration by loading the "core" module,
-- which lives at lua/core/init.lua and is responsible for pulling in
-- options, the plugin manager, and all key mappings.
require("core")
