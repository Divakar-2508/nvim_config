return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason-lspconfig").setup({})
            local lsp_config = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            lsp_config.lua_ls.setup({})
            lsp_config.gopls.setup({})
            lsp_config.jdtls.setup({})
            lsp_config.pyright.setup({
                capabilities = capabilities
            })

            lsp_config.tailwindcss.setup {}
            lsp_config.html.setup {
                filetypes = { "typescriptreact", "html" }
            }
            lsp_config.tsserver.setup {
                filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
                cmd = { "typescript-language-server", "--stdio" }
            }

            local signs = {
                Error = "",
                Warn = "",
                Hint = "",
                Info = ""
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },
}
