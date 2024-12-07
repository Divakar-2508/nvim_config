return {
    {   "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000,
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            })
        end
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = {{"echasnovski/mini.icons", opts = {}}},
        config = function()
            -- Setup oil.nvim with floating window
            require("oil").setup(
                {
                    float = {
                        enabled = true, -- Enable floating window for Oil
                        size = {
                            -- Define window size: width and height as percentages
                            width = 0.8, -- 80% of the screen width
                            height = 0.8 -- 80% of the screen height
                        },
                        border = "rounded",
                        winblend = 10, 
                        highlights = {
                            border = "Normal",
                            background = "Normal"
                        },
                        position = {
                            row = 0.1, -- 10% from top
                            col = 0.1 -- 10% from left
                        }
                    },
                    view_options = {
                        show_hidden = true,
                        is_diagnostics_shown = false
                    }
                }
            )

            -- Set the keymap for opening the parent directory with Oil
            vim.keymap.set(
                "n",
                "-",
                function()
                    require("oil").open(vim.fn.getcwd()) -- Open the current working directory
                end,
                {desc = "Open parent directory with Oil"}
            )
        end
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = {"echasnovski/mini.icons"}, -- Optional for icons
        config = function()
            require("fzf-lua").setup(
                {
                    winopts = {
                        height = 0.85, -- window height
                        width = 0.80, -- window width
                        row = 0.30, -- window row position
                        col = 0.50, -- window col position
                        border = "rounded" -- border style
                    },
                    files = {
                        prompt = "Files❯ ",
                        cmd = "fd --type f --hidden --follow --exclude .git", -- Use fd for file search
                        git_icons = true, -- Show git icons for files
                        file_icons = true -- Show file type icons
                    },
                    grep = {
                        rg_opts = "--column --line-number --no-heading --color=always --smart-case",
                        exact = false,
                        case_mode = "smart_case"
                        -- prompt = "Rg❯ ",
                        -- cmd = "rg --vimgrep" -- Use ripgrep for searching
                    },
                    previewers = {
                        bat = {
                            cmd = "bat",
                            args = "--style=numbers,changes --color always",
                            theme = "OneHalfDark", -- Set the theme for bat
                            config = nil -- Set this to a custom bat config file if needed
                        }
                    }
                }
            )
            local fzf = require("fzf-lua")
            vim.keymap.set("n", "<leader>f", fzf.files, {desc = "Fuzzy search files"})
            vim.keymap.set("n", "<leader>s", fzf.lsp_workspace_symbols, {desc = "Search workspace symbols"})
            vim.keymap.set("n", "<leader>rg", fzf.grep, {desc = "Search with ripgrep"})
            vim.keymap.set("n", "<leader>b", fzf.buffers, {desc = "Switch buffers"})
            vim.keymap.set("n", "<leader>l", fzf.live_grep, {desc = "Live grep search"})
            vim.keymap.set("n", "<leader>t", fzf.tags, {desc = "Search tags"})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            -- Specify the compiler for Windows
            require("nvim-treesitter.install").compilers = {"clang"}

            -- Treesitter setup
            require("nvim-treesitter.configs").setup(
                {
                    ensure_installed = {"rust", "python", "lua", "go", "cpp"}, -- Add any languages you need
                    highlight = {
                        enable = true, -- Enable syntax highlighting
                        disable = {} -- Disable highlighting for certain languages (optional)
                    },
                    incremental_selection = {
                        enable = true, -- Enable incremental selection
                        keymaps = {
                            init_selection = "gnn",
                            node_incremental = "grn",
                            scope_incremental = "grc",
                            node_decremental = "grm"
                        }
                    },
                }
            )
        end
    },
    {
        "ojroques/nvim-hardline",
        config = function()
            require("hardline").setup(
                {
                    bufferline = true
                }
            )
        end
    },
    {
        "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
        lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
        dependencies = {
            -- main one
            {"ms-jpq/coq_nvim", branch = "coq"},
            -- 9000+ Snippets
            {"ms-jpq/coq.artifacts", branch = "artifacts"},
            -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
            -- Need to **configure separately**
            {"ms-jpq/coq.thirdparty", branch = "3p"}
            -- - shell repl
            -- - nvim lua api
            -- - scientific calculator
            -- - comment banner
            -- - etc
        },
        init = function()
            vim.g.coq_settings = {
                auto_start = 'shut-up',
            }
        end,
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.rust_analyzer.setup {}
        end,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = true,
			command = "cargo clippy",
		},
	}
    },
    -- {
    --    'mrcjkb/rustaceanvim',
    --    version = '^5', -- Recommended
    --    lazy = false, -- This plugin is already lazy
    -- }
}

