---@type ChadrcConfig 
require "custom.options"

local M = {}

M.ui = {
  theme = 'nightfox',
  hl_override = {
    CursorLine = {
      bg = "#161b26"
    }
  }
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M

