local plugins = {
  -- allows for easy switching between nvim and terms within tmux
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  -- language server
  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'plugins.configs.lspconfig'
      require 'custom.configs.lspconfig'
    end
  },
  -- package manager for lsp
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'pyright',
        'typescript-language-server',
      }
    }
  }
}

return plugins
