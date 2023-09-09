local plugins = {
    -- syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
            opts = {
            ensure_installed = {
                'bash',
                'c',
                'c_sharp',
                'cpp',
                'css',
                'go',
                'html',
                'javascript',
                'json',
                'python',
                'rust',
                'sql',
                'tsx',
                'typescript',
                'vim',
                'xml',
                'yaml',
            },
        },
    },
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
    },
    -- go plugin
    {
        'ray-x/go.nvim',
        config = function()
            require('go').setup()
        end,
        event = {'CmdlineEnter'},
        ft = {'go', 'gomod'},
        build = ':lua require("go.install").update_all_sync()'
    },
}

return plugins
