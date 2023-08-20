---@type ChadrcConfig 
-- load custom options
require "custom.options"

local M = {}

M.ui = {
  -- set theme
  theme = 'everforest',
  -- customize cursorline highlight
  hl_override = {
    CursorLine = {
      bg = "one_bg"
    }
  }
}
-- load custom plugins
M.plugins = "custom.plugins"
-- load custom keymaps
M.mappings = require "custom.mappings"

return M

