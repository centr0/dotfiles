-- custom mappings

local M = {}

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
M.centro = {

}
return M
