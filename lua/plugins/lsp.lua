return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},
	opts = {
		servers = {
			lua_ls = {},
			pyright = {},
			html = {},
			jdtls = {},
			clangd = {
				cmd = {
					"clangd",
					"--clang-tidy",
					"--enable-config",
				},
			},
			omnisharp = {},
			svelte = {},
			ts_ls = {},
		},
	},
	config = function(_, opts)
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"clangd",
				"pyright",
				"jdtls",
				"csharp_ls",
				"svelte",
				"ts_ls",
			},
		})

		local lspconfig = require("lspconfig")

		for server, config in pairs(opts.servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}

-- vim.o.winbar = "%{%v:lua.require'breadcrumb'.get()%}"
