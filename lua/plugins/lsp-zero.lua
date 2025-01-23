return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {},
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
        init = function()
            vim.g.rustaceanvim = {
                tools = {
                    -- (e.g. inlay hints, etc.)
                },
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                targetDir = true,
                            },
                            check = {
                                allTargets = true,
                                command = "clippy",
                            },
                            diagnostics = {
                                disabled = { "inactive-code" },
                            },
                            procMacro = { enable = true },
                            flags = { exit_timeout = 100 },
                            files = {},
                        },
                    },
                },
            }
        end,
    },

    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        init = function()
            vim.opt.signcolumn = "yes" -- Reserve space in the gutter
        end,
        config = function()
            local lsp_defaults = require("lspconfig").util.default_config
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                "force",
                lsp_defaults.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "x" }, "<F3>", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
                end,
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "nil_ls",
                    "ts_ls",
                    "gopls",
                    "eslint",
                    "lua_ls",
                },
                handlers = {
                    function(server_name)
                        if server_name == "rust_analyzer" then
                            return
                        end

                        if server_name == "nil_ls" then
                            require("lspconfig").nil_ls.setup({
                                settings = {
                                    ["nil"] = {
                                        formatting = { command = { "nixpkgs-fmt" } },
                                    },
                                },
                            })
                            return
                        end

                        -- All other servers
                        require("lspconfig")[server_name].setup({})
                    end,
                },
            })
        end,
    },
}
