vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({
        'rose-pine/neovim',
        as = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'simrat39/rust-tools.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
            require("fidget").setup {
                -- options
            }
        end,
    }

    -- Lua
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                position = "bottom",            -- position of the list can be: bottom, top, left, right
                height = 10,                    -- height of the trouble list when position is top or bottom
                width = 50,                     -- width of the list when position is left or right
                icons = false,                  -- use devicons for filenames
                mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
                fold_open = "v",                -- icon used for open folds
                fold_closed = ">",              -- icon used for closed folds
                group = true,                   -- group results by file
                padding = true,                 -- add an extra new line on top of the list
                action_keys = {                 -- key mappings for actions in the trouble list
                    -- map to {} to remove a mapping, for example:
                    -- close = {},
                    close = "q",                   -- close the list
                    cancel = "<esc>",              -- cancel the preview and get back to your last window / buffer / cursor
                    refresh = "r",                 -- manually refresh
                    jump = { "<cr>", "<tab>" },    -- jump to the diagnostic or open / close folds
                    open_split = { "<c-x>" },      -- open buffer in new split
                    open_vsplit = { "<c-v>" },     -- open buffer in new vsplit
                    open_tab = { "<c-t>" },        -- open buffer in new tab
                    jump_close = { "o" },          -- jump to the diagnostic and close the list
                    toggle_mode = "m",             -- toggle between "workspace" and "document" diagnostics mode
                    toggle_preview = "P",          -- toggle auto_preview
                    hover = "K",                   -- opens a small popup with the full multiline message
                    preview = "p",                 -- preview the diagnostic location
                    close_folds = { "zM", "zm" },  -- close all folds
                    open_folds = { "zR", "zr" },   -- open all folds
                    toggle_fold = { "zA", "za" },  -- toggle fold of current file
                    previous = "k",                -- preview item
                    next = "j"                     -- next item
                },
                indent_lines = false,              -- add an indent guide below the fold icons
                auto_close = true,                 -- automatically close the list when you have no diagnostics
                auto_preview = true,               -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
                auto_fold = false,                 -- automatically fold a file trouble list at creation
                auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
                signs = {
                    -- icons / text used for a diagnostic
                    error = "error",
                    warning = "warn",
                    hint = "hint",
                    information = "info"
                },
                use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
                opts = {
                    modes = {
                        diagnostics = {
                            auto_open = true
                        }
                    }
                },
            }
        end
    }
end)
