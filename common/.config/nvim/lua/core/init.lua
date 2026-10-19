-- Load order matters: options must be first so that leader key and other
-- globals are defined before lazy.nvim or any plugin tries to read them.
require("core.options") -- options must be the first file to load

-- Set up the lazy.nvim plugin manager and register all plugins found under
-- the lua/plugins/ directory. Lazy defers plugin loading until they are
-- actually needed, which keeps startup time fast.
require("core.lazy")

-- Register all custom key mappings that are not tied to a specific plugin.
-- Plugin-specific mappings live inside each plugin's own config function.
require("core.keymap")
