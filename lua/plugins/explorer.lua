---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim", lazy = true },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "_",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-->",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
--[[ return	{
		"stevearc/oil.nvim",
		opts = {},
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			-- Setup oil.nvim with floating window
			require("oil").setup({
				float = {
					enabled = true, -- Enable floating window for Oil
					size = {
						-- Define window size: width and height as percentages
						width = 0.8, -- 80% of the screen width
						height = 0.8, -- 80% of the screen height
					},
					border = "rounded",
					winblend = 10,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
					position = {
						row = 0.1, -- 10% from top
						col = 0.1, -- 10% from left
					},
				},
				view_options = {
					show_hidden = true,
					is_diagnostics_shown = false,
				},
				attach = function(bufnr)
					local oil = require("oil")
					local opts = { buffer = bufnr, noremap = true, silent = true }

					-- Left Arrow (←) - Go up one directory
					vim.keymap.set("n", "<Left>", function()
						oil.open("..") -- Open parent directory
					end, opts)

					-- Right Arrow (→) - Enter the directory under the cursor
					vim.keymap.set("n", "<Right>", function()
						oil.select() -- Enter selected directory
					end, opts)

					-- Underscore (_) - Open workspace directory
					vim.keymap.set("n", "_", function()
						oil.open(vim.loop.cwd()) -- Open workspace directory
					end, opts)
				end,
			})

			local oil = require("oil")

			-- Set the keymap for opening the parent directory with Oil
			vim.keymap.set("n", "-", function()
				oil.open(vim.fn.expand("%:p:h")) -- Open the current working directory
			end, { desc = "Open parent directory with Oil" })
		end,
	} ]]
