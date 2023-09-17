local M = {}
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    M.cmp = {
        completion = {
            preselect = cmp.PreselectMode.None,
            completeopt = "menu, menuone, noselect, noinsert",
        },
        mapping = {
            ["<CR>"] = cmp.mapping.confirm { select = false },
        }
    }
end

return M
