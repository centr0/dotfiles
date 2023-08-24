---@type ChadrcConfig 
-- load custom options
require "custom.options"

local M = {}

M.ui = {
  -- set theme
  theme = 'ayu_dark',
  changed_themes = {
    ayu_dark = {
      base_16 = {
        base0F = "#E6E1CF"
      },
    },
  },
  -- customize cursorline highlight
  hl_override = {
    CursorLine = {
      bg = "one_bg"
    }
  },
  nvdash = {
    load_on_startup = true,
    header = {
      "░█████╗░███████╗███╗░░██╗████████╗██████╗░░█████╗░",
      "██╔══██╗██╔════╝████╗░██║╚══██╔══╝██╔══██╗██╔══██╗",
      "██║░░╚═╝█████╗░░██╔██╗██║░░░██║░░░██████╔╝██║░░██║",
      "██║░░██╗██╔══╝░░██║╚████║░░░██║░░░██╔══██╗██║░░██║",
      "╚█████╔╝███████╗██║░╚███║░░░██║░░░██║░░██║╚█████╔╝",
      "░╚════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}
-- load custom plugins
M.plugins = "custom.plugins"
-- load custom keymaps
M.mappings = require "custom.mappings"

return M

