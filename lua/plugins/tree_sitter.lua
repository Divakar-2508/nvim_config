return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "rust", "go", "html", "css", "java" },
            sync_install = false,
            compilers = { "clang" },
            highlight = { enable = true },
            indent = { enable = true },
        })

        require("nvim-treesitter.install").compilers = { "clang" }
    end
}
