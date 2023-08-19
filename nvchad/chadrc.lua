---@type ChadrcConfig 
require "custom.options"

local M = {}

M.ui = {
  theme = 'everforest',
  hl_override = {
    CursorLine = {
      bg = "one_bg"
    }
  }
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M

