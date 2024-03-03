local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

local rust_tools = require('rust-tools')

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'nil_ls',
        'tsserver',
        'gopls',
        'eslint',
        'lua_ls'
    },
    handlers = {
        lsp.default_setup,
        rust_analyzer = function()
            rust_tools.setup({
                tools = {
                    autoSetHints = true,
                    inlay_hints = {
                        show_parameter_hints = true,
                        other_hints_prefix = "» ",
                    },
                },

                -- all the opts to send to nvim-lspconfig
                -- these override the defaults set by rust-tools.nvim
                -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
                server = {
                    -- Find out what this does
                    -- cmd = { '@rustAnalyzer@/bin/rust-analyzer' },

                    before_init = function(_, config)
                        -- Override clippy to run in its own directory to avoid clobbering caches
                        -- but only if target-dir isn't already set in either the command or the extraArgs
                        local cargo = config.settings["rust-analyzer"].cargo;

                        -- Lua apparently interprets `-` as a pattern and writing `%-` escapes it(!)
                        local needle = "%-%-target%-dir";

                        local extraArgs = cargo.extraArgs;
                        for _, v in pairs(extraArgs) do
                            if string.find(v, needle) then
                                return
                            end
                        end

                        local target_dir = config.root_dir .. "/target/ide-clippy";
                        table.insert(extraArgs, "--target-dir=" .. target_dir);
                    end,
                    settings = {
                        -- to enable rust-analyzer settings visit:
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                extraArgs = {
                                    -- --target-dir injected above
                                },
                            },
                            -- enable clippy on save
                            check = {
                                allTargets = true,
                                command = "clippy",
                            },
                            diagnostics = {
                                disabled = { "inactive-code" }
                            },
                            procMacro = {
                                enable = true,
                            },
                        }
                    },
                    on_attach = function(_, bufnr)
                        vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, { buffer = bufnr })
                    end
                }
            })
        end,
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    })
})

-- lsp.set_preferences({
--     sign_icons = {  }
-- })

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
