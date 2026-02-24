return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").filetype_extend("jsp", { "html" })
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/snippets" })
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		version = "*",
		opts = {
			snippets = {
				preset = "luasnip",
			},
			keymap = {
				preset = "default",
				["<Tab>"] = {
					function(cmp)
						if not cmp.snippet_active() then
							return cmp.select_next()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if not cmp.snippet_active() then
							return cmp.select_prev()
						end
					end,
					"snippet_backward",
					"fallback",
				},
				["<CR>"] = { "accept", "fallback" },
				["<C-space>"] = {
					function(cmp)
						cmp.show({ providers = { "snippets", "buffer", "lsp" } })
					end,
				},
			},
			signature = { enabled = true },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
