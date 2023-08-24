local opt = vim.opt
opt.cursorline = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
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
-- use vim.cmd() to run vim commands in lua
-- vim.opt.guicursor:append('v-sm:block-ModesVisual')
