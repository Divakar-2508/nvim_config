return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},
	opts = {
		servers = {
			lua_ls = {},
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							extraPaths = { "." }, -- 👈 add this
						},
					},
				},
			},
			html = {},
			-- jdtls = {},
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
			bashls = {},
		},
	},
	config = function(_, opts)
		-- require("mason").setup()

		local lspconfig = require("lspconfig")

		for server, config in pairs(opts.servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}

-- vim.o.winbar = "%{%v:lua.require'breadcrumb'.get()%}"
