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
            lsp_config.lua_ls.setup({})
        end,
    },
}
