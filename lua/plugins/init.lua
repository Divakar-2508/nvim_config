return {
	{
		"loctvl842/monokai-pro.nvim",
		config = function()
			vim.cmd("colorscheme monokai-pro-spectrum")
		end,
	},
	{
		"windwp/nvim-autopairs",
		lazy = true,
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt", lsp_format = "fallback" },
					html = { "prettier" },
					css = { "prettier" },
					csharp = { "csharpier" },
					python = {
						"ruff_fix",
						"ruff_format",
						"ruff_organize_imports",
					},
					asm = { "asmfmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { { "echasnovski/mini.icons", opts = {} } }, -- Optional for icons
		config = function()
			require("fzf-lua").setup({
				winopts = {
					height = 0.85, -- window height
					width = 0.80, -- window width
					row = 0.30, -- window row position
					col = 0.50, -- window col position
					border = "rounded", -- border style
				},
				files = {
					prompt = "Files❯ ",
					cmd = "fd --type f --hidden --follow --exclude .git", -- Use fd for file search
					git_icons = true, -- Show git icons for files
					file_icons = true, -- Show file type icons
				},
				grep = {
					rg_opts = "--column --line-number --no-heading --color=always --smart-case",
					exact = false,
					case_mode = "smart_case",
					-- prompt = "Rg❯ ",
					-- cmd = "rg --vimgrep" -- Use ripgrep for searching
				},
				previewers = {
					bat = {
						cmd = "bat",
						args = "--style=numbers,changes --color always",
						theme = "OneHalfDark", -- Set the theme for bat
						-- theme = "monokai-pro-spectrum",
						config = nil, -- Set this to a custom bat config file if needed
					},
				},
			})
			local fzf = require("fzf-lua")
			vim.keymap.set("n", "<leader>f", fzf.files, { desc = "Fuzzy search files" })
			vim.keymap.set("n", "<leader>s", fzf.lsp_workspace_symbols, { desc = "Search workspace symbols" })
			vim.keymap.set("n", "<leader>S", fzf.lsp_live_workspace_symbols, { desc = "Search live workspace symbols" })
			vim.keymap.set("n", "<leader>rg", fzf.grep, { desc = "Search with ripgrep" })
			vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Switch buffers" })
			vim.keymap.set("n", "<leader>l", fzf.live_grep, { desc = "Live grep search" })
			vim.keymap.set("n", "<leader>t", fzf.tags, { desc = "Search tags" })
			vim.keymap.set("n", "<leader>df", function()
				fzf.lsp_document_symbols({
					symbol_kind = { "Method" },
					prompt = "Funcs❯ ",
				})
			end, { desc = "Search functions in current buffer" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		event = "BufReadPre",
		config = function()
			-- Specify the compiler for Windows
			-- require("nvim-treesitter.install").compilers = { "gcc" }

			-- Treesitter setup
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "rust", "python", "lua", "cpp", "java", "c" }, -- Add any languages you need
				highlight = {
					enable = true, -- Enable syntax highlighting
					disable = {}, -- Disable highlighting for certain languages (optional)
				},
				incremental_selection = {
					enable = true, -- Enable incremental selection
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		lazy = true,
		config = function()
			require("mason-lspconfig").setup({
				handlers = {},
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"numToStr/Comment.nvim",
		lazy = true,
		config = function()
			require("Comment").setup({})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		event = "BufWritePost",
		config = function()
			local lint = require("lint")

			-- Set up linters for different file types
			lint.linters_by_ft = {
				rust = { "clippy" },
				-- cpp = { "clangtidy" },
				javascript = { "eslint_d" },
				python = { "ruff" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.api.nvim_create_user_command("LintNow", function()
				print("Running Linter...")
				lint.try_lint()
				print("Lint finished...")
			end, {})

			vim.defer_fn(function()
				lint.try_lint()
			end, 100)
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			local jdtls = require("jdtls")
			local home = os.getenv("HOME")

			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

			-- read package from the top of the buffer (if any)
			local function package_from_buffer()
				local ok, lines = pcall(vim.api.nvim_buf_get_lines, 0, 0, 40, false)
				if not ok then
					return nil
				end
				for _, line in ipairs(lines) do
					local pkg = line:match("^%s*package%s+([%w_.]+)%s*;")
					if pkg then
						return pkg
					end
				end
				return nil
			end

			-- find a sensible Java "root_dir"
			local function find_java_root()
				-- 1) project root markers (maven/gradle/git)
				local found = require("jdtls.setup").find_root(root_markers)
				if found and #found > 0 then
					return found
				end

				-- 2) if no project markers: try package heuristic
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then
					return vim.fn.getcwd()
				end
				local filedir = vim.fn.fnamemodify(bufname, ":p:h")
				local pkg = package_from_buffer()
				if pkg then
					local pkg_path = pkg:gsub("%.", "/")
					-- if filedir ends with the package path, strip it off to get the source root
					local base = filedir:match("^(.*)/" .. pkg_path .. "$")
					if base and base ~= "" then
						return base
					end
				end

				-- 3) fallback to the file's folder
				return filedir
			end

			local root_dir = find_java_root()
			local workspace_folder = home .. "/.cache/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

			local config = {
				cmd = {
					"java",
					"--enable-native-access=ALL-UNNAMED",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					vim.fn.glob(
						home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
					),
					"-configuration",
					home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
					"-data",
					workspace_folder,
				},
				root_dir = root_dir,
				-- you can add settings/init_options here if you use them
			}

			print("jdtls: starting with root_dir = " .. root_dir) -- useful for quick debug
			jdtls.start_or_attach(config)
		end,
	},
}
