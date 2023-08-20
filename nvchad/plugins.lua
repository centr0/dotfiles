local plugins = {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'plugins.configs.lspconfig'
      require 'custom.configs.lspconfig'
    end
  },
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
