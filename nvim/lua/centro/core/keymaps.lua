vim.g.mapleader = " " -- leader <Space>

local keymap = vim.keymap

-- general keymaps
keymap.set("i", "jk", "<ESC>")

-- clears search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- increment or decrement numbers in n mode
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- split window
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make splut windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window 

-- manage tabs
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab 
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab 
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab 
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to prev tab

-- plugin keymaps --------------------------------------------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree toggle
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- fuzzy finding
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, {}) 
keymap.set("n", "<leader>fs", builtin.live_grep, {})
keymap.set("n", "<leader>fc", builtin.grep_string, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})
