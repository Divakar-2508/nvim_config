return {
    {
        "loctvl842/monokai-pro.nvim",
        version = "v1.26.1",
        lazy = false,
        priority = 1000,
        config = function()
            require("monokai-pro").setup({
                filter = "spectrum",
            })
            vim.cmd.colorscheme("monokai-pro")
        end,
    },
    {
        "windwp/nvim-autopairs",
        lazy = true,
        event = "InsertEnter",
        config = true,
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
                    jsp = { "prettier" },
                    css = { "prettier" },
                    csharp = { "csharpier" },
                    python = {
                        "ruff_fix",
                        "ruff_format",
                        "ruff_organize_imports",
                    },
                    asm = { "asmfmt" },
                    xml = { "xmlformatter" },
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
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.80,
                    row = 0.30,
                    col = 0.50,
                    border = "rounded",
                },
                files = {
                    prompt = "Files❯ ",
                    cmd = 'fd --type f --hidden --follow --exclude .git --exclude .hg --exclude "**/*.class"',
                    git_icons = true,
                    file_icons = true,
                },
                grep = {
                    rg_opts = "--column --line-number --no-heading --color=always --smart-case",
                    exact = false,
                    case_mode = "smart_case",
                    prompt = "Rg❯ ",
                    cmd = "rg --vimgrep", -- Use ripgrep for searching
                    silent = true,
                },
                previewers = {
                    bat = {
                        cmd = "bat",
                        args = "--style=numbers,changes --color always",
                        theme = "OneHalfDark", -- Set the theme for bat
                        config = nil,
                    },
                },
                silent = true,
            })

            -- require("fzf-lua").register_ui_select()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()
            local ensure_installed = { "rust", "python", "lua", "cpp", "java", "c" }

            require("nvim-treesitter").setup({
                ensure_installed = ensure_installed,
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })


            vim.api.nvim_create_autocmd('FileType', {
                pattern = ensure_installed,
                callback = function() vim.treesitter.start() end,
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        -- lazy = true,
        cmd = "Mason",
        config = function()
            require("mason").setup()
            --
            -- local list = {
            --     "clangd", "rust-analyzer", "pyright", "lua-language-server", "ruff"
            -- }
            --
            -- for _, pkg in pairs(list) do
            --     vim.cmd("MasonInstall " .. pkg)
            -- end
        end,
    },
    -- {
    -- 	"mrcjkb/rustaceanvim",
    -- 	version = "^5", -- Recommended
    -- 	lazy = false, -- This plugin is already lazy
    -- },
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
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        -- -@type render.md.UserConfig
        opts = {},
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java", "jsp" },
        config = function()
            local jdtls = require("jdtls")

            local home = os.getenv("HOME")

            -- 🔒 HARD PIN YOUR JVM (good choice btw)
            local java_bin = "/usr/lib/jvm/java-21-openjdk-amd64/bin/java"

            -- 📦 Mason paths
            local mason_path = vim.fn.stdpath("data") .. "/mason"
            local jdtls_path = mason_path .. "/packages/jdtls"

            -- 🫙 Launcher JAR (must be globbed, name changes)
            local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

            -- 🌱 Root detection
            ROOT_DIR = require("jdtls.setup").find_root({
                ".git",
                "pom.xml",
                "build.gradle",
                "build.gradle.kts",
                "settings.gradle",
                "settings.gradle.kts",
                "build.xml",
                ".hg"
            })

            if not ROOT_DIR then
                return
            end

            -- 🧠 Workspace (per-project, no collisions)
            local project_name = vim.fn.fnamemodify(ROOT_DIR, ":p:h:t")
            local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

            -- 🚀 Final config
            local config = {
                cmd = {
                    java_bin,
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.protocol=true",
                    "-Dlog.level=ALL",
                    "-Xmx2g",

                    "-jar",
                    launcher,
                    "-configuration",
                    jdtls_path .. "/config_linux", -- mac: config_mac
                    "-data",
                    workspace_dir,
                },

                root_dir = ROOT_DIR,

                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        contentProvider = { preferred = "fernflower" },
                        project = {
                            sourcePaths = { "src" }, -- "source"
                            referencedLibraries = {
                                "lib/**/*.jar",
                            },
                        },
                    },
                },

                init_options = {
                    bundles = {},
                },
            }

            -- 🧲 Attach


            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "java", "jsp" },
                callback = function()
                    jdtls.start_or_attach(config)
                end
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    {
        "cameron-wags/rainbow_csv.nvim",
        config = true,
        ft = {
            "csv",
            "tsv",
            "csv_semicolon",
            "csv_whitespace",
            "csv_pipe",
            "rfc_csv",
            "rfc_semicolon",
        },
        cmd = {
            "RainbowDelim",
            "RainbowDelimSimple",
            "RainbowDelimQuoted",
            "RainbowMultiDelim",
        },
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            require("nvim-navic").setup({
                highlight = true,
                separator = " > ",
                -- depth_limit = 5,
                -- depth_limit_indicator = "..",
            })
        end,
        {
            'phaazon/hop.nvim',
            branch = 'v2', -- optional but strongly recommended
            config = function()
                -- you can configure Hop the way you like here; see :h hop-config
                local hop = require('hop')
                hop.setup { keys = 'etovxqpdygfblzhckisuran' }
                vim.keymap.set("n", "<leader><leader>", ":HopWord<CR>", { desc = "Hop Word", silent = true })
            end
        }
    }
    --[[ {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lspsaga").setup({
                -- 🌈 UI
                ui = {
                    border = "rounded",
                    title = true,
                    expand = "",
                    devicon = true,
                    collapse = "",
                    code_action = "💡",
                    actionfix = "",
                    lines = { "┗", "┣", "┃", "━", "┏" },
                    kind = {},
                    colors = {
                        normal_bg = "#1e222a",
                        title_bg = "#1e222a",
                        red = "#ec5f67",
                        magenta = "#c678dd",
                        orange = "#d19a66",
                        yellow = "#e5c07b",
                        green = "#98c379",
                        cyan = "#56b6c2",
                        blue = "#61afef",
                        purple = "#c678dd",
                        white = "#abb2bf",
                        black = "#1e222a",
                    },
                },

                -- 💡 Code Action
                code_action = {
                    num_shortcut = true,
                    show_server_name = true,
                    extend_gitsigns = true,
                    layout = "down",
                    close_after = true,
                },

                -- 🔍 Finder (definitions, references, impls)
                finder = {
                    max_height = 0.6,
                    min_width = 30,
                    default = "ref+def+imp",
                    layout = "float",
                    silent = false,
                    keys = {
                        toggle_or_open = "<CR>",
                        vsplit = "v",
                        split = "s",
                        quit = { "q", "<ESC>" },
                    },
                },

                -- 📖 Hover Doc
                hover = {
                    max_width = 0.6,
                    open_link = "gx",
                    open_browser = "!xdg-open",
                },

                -- 🧠 Rename
                rename = {
                    in_select = true,
                    auto_save = false,
                    keys = {
                        quit = "<ESC>",
                        exec = "<CR>",
                        select = "x",
                    },
                },

                -- 🚨 Diagnostics
                diagnostic = {
                    on_insert = false,
                    on_insert_follow = false,
                    show_code_action = true,
                    show_source = true,
                    jump_num_shortcut = true,
                    max_width = 0.7,
                    keys = {
                        quit = "q",
                        exec_action = "<CR>",
                    },
                },

                -- 🌳 Outline
                outline = {
                    win_position = "right",
                    win_width = 30,
                    auto_preview = true,
                    detail = true,
                },

                -- 🧭 Symbol in winbar
                symbol_in_winbar = {
                    enable = true,
                    separator = "  ",
                    hide_keyword = false,
                    show_file = true,
                    folder_level = 2,
                },

                -- ✨ Lightbulb
                lightbulb = {
                    enable = true,
                    enable_in_insert = false,
                    sign = false,
                    sign_priority = 40,
                    virtual_text = true,
                },
            })
        end,
    }, ]]
}
