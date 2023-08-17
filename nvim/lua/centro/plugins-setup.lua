-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
    use "wbthomason/packer.nvim"  -- packer

    -- lua functions that many plugins use
    use "nvim-lua/plenary.nvim"
 
    use "bluz71/vim-nightfly-guicolors"  -- color scheme

    -- tmux & split window nav. <C-h/j/k/l> to nav through panes
    use "christoomey/vim-tmux-navigator"
    
    -- maximizes and restores current window
    use "szw/vim-maximizer" 

    -- surround text w/ a character
    -- ys<motion><char>: wraps with char 
    -- ds<char>: removes wrapped chars
    -- cs<char-you-want-to-change><char>: replaces char with another char
    use "tpope/vim-surround"

    -- commenting with gc
    use "numToStr/Comment.nvim"

    -- file explorer
    use "nvim-tree/nvim-tree.lua"

    -- icons
    use "kyazdani42/nvim-web-devicons"

    -- status line
    use "nvim-lualine/lualine.nvim"

    -- fuzzy finding
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } -- dependency to speed up telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
-- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- autocomplete
    use "hrsh7th/nvim-cmp" -- completin plugin
    use "hrsh7th/cmp-buffer" -- source for text in buffer
    use "hrsh7th/cmp-path" -- source for file system paths

    -- snippets
    use { -- snippet engine
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    }
    use "saadparwaiz1/cmp_luasnip" -- for autocompletion
    use "rafamadriz/friendly-snippets" -- useful snippets 

    if packer_bootstrap then
        require("packer").sync()
    end
end)
