local opt = vim.opt
opt.cursorline = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.relativenumber = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.backspace = 'indent,eol,start'
opt.clipboard:append('unnamedplus')
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append('-')
opt.guicursor = ""
opt.completeopt="menu,menuone,noinsert,noselect"
-- Run gofmt on save
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').gofmt()
  end,
  group = format_sync_grp,
})

-- transparent background
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
vim.api.nvim_set_hl(0, "EndOfBuffer", {bg = "none"})
vim.api.nvim_set_hl(0, "StatusLine", {bg = "none"})
