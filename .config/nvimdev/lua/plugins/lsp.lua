return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            { "williamboman/mason.nvim",           opts = true },
            { "williamboman/mason-lspconfig.nvim", opts = true },
        },
        opts = {
            ensure_installed = {
                "pyright", -- LSP for python
                "ruff",    -- linter & formatter (includes flake8, pep8, black, isort, etc.)
                "debugpy", -- debugger
                "taplo",   -- LSP for toml (e.g., for pyproject.toml files)
                "django-template-lsp",
                "gopls"
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local lsp = require "lspconfig"
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            lsp.lua_ls.setup { capabilities = capabilities }
            lsp.pyright.setup { capabilities = capabilities }
            lsp.ruff.setup({
                -- disable ruff as hover provider to avoid conflicts with pyright
                on_attach = function(client) client.server_capabilities.hoverProvider = false end,
            })
            lsp.rust_analyzer.setup { capabilities = capabilities }
            lsp.gopls.setup {}
            lsp.bashls.setup { capabilities = capabilities }
            lsp.ts_ls.setup {
                capabilities = capabilities,
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            }

            lsp.djlsp.setup {
                cmd = { "djlsp" },
            }

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    ---@diagnostic disable-next-line: param-type-mismatch
                    if client.supports_method('textDocument/formatting') then
                        -- Format the current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end,

                        })
                    end
                end,
            })
        end,

    }
}
