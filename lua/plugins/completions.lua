return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = {
				function(cmp)
					if not cmp.snippet_active() then
						return cmp.select_next()
						-- else
						-- 	return cmp.accept()
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
}
