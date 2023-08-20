-- custom mappings

local M = {}
-- override nvchad bindings
M.general = {
  n = {
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left"},
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right"},
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down"},
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up"},

  }
}

-- disable default keymap
M.disabled = {
  n = {
    ["<leader>fw"] = "",
  }
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
  }
}

-- my custom mappings
M.custom = {
  n = {
    ["<leader>sv"] = {"<cmd>vs<CR>", "Split vertically"},
    ["<leader>sh"] = {"<cmd>sp<CR>", "Split horizonally"}
  }
}
return M
