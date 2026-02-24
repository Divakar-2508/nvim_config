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
							extraPaths = { "." },
						},
					},
				},
			},
			rust_analyzer = {},
			html = {
				filetypes = { "html", "jsp" },
			},
			clangd = {
				cmd = {
					"clangd",
					"--clang-tidy",
					"--enable-config",
				},
			},
			omnisharp = {},
			-- svelte = {},
			ts_ls = {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "jsp" },
			},
			bashls = {},
			cssls = {},
			postgres_lsp = {
				workspace_required = false,
			},
			-- jdtls = {},
		},
	},
	config = function(_, opts)
		-- local lspconfig = require("lspconfig")

		-- Configure lemminx for XML schemas
		vim.lsp.config.lemminx = {
			filetypes = { "xml", "ant" },
			settings = {
				xml = {
					fileAssociations = {
						{
							pattern = "**/build.xml", -- match exactly abc.xml anywhere
							systemId = vim.fn.expand("~/.config/nvim/schema/ant-custom.xsd"),
						},
					},
				},
			},
		}
		vim.lsp.enable("lemminx")

		-- other servers
		for server, config in pairs(opts.servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			-- lspconfig[server].setup(config)
			vim.lsp.config[server] = config
			vim.lsp.enable(server)
		end
	end,
}
