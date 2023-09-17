local cmp = require("cmp")
cmp.setup({
    enabled = true,
    preselect = cmp.PreselectMode.None,
    completion = {
        completeopt = "menu,menuone,noinsert,noselect"
    }
})
