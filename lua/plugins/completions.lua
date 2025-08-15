return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
		},
		version = "*",
		opts = {
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
						cmp.show({ providers = { "snippets" } })
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
