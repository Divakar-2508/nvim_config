vim.g.mapleader = " "

vim.keymap.set("n", "<M-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

--clear highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- vim.keymap.set("n", "cc", "ggVGy")
vim.keymap.set("n", "yf", "ggVGy")

-- navigate windows
vim.keymap.set("n", "<C-q>", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { noremap = true, silent = true })

-- switch tabs
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })

-- close buffer
vim.keymap.set("n", "<leader>x", ":bd<CR>", { silent = true })

-- Line Comment
vim.keymap.set(
    "n",
    "<leader>/l",
    "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    { desc = "Toggle Line Comment" }
)
vim.keymap.set(
    "v",
    "<leader>/l",
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = "Toggle Line Comment" }
)

-- Block Comment
vim.keymap.set(
    "n",
    "<leader>/b",
    "<cmd>lua require('Comment.api').toggle.blockwise.current()<CR>",
    { desc = "Toggle Block Comment" }
)
vim.keymap.set(
    "v",
    "<leader>/b",
    "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>",
    { desc = "Toggle Block Comment" }
)

-- Window Height
vim.keymap.set("n", "<M-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })

-- fzf-lua
local ok, fzf = pcall(require, "fzf-lua")
if ok then
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    map("n", "<leader>f", fzf.files, vim.tbl_extend("force", opts, { desc = "Fuzzy search files" }))
    map("n", "<leader>s", fzf.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Search document symbols" }))
    map(
        "n",
        "<leader>S",
        fzf.lsp_live_workspace_symbols,
        vim.tbl_extend("force", opts, { desc = "Search  workspace symbols" })
    )
    map(
        "n",
        "<leader>d",
        fzf.diagnostics_document,
        vim.tbl_extend("force", opts, { desc = "Search diagnostic documents " })
    )
    map(
        "n",
        "<leader>D",
        fzf.diagnostics_workspace,
        vim.tbl_extend("force", opts, { desc = "Search diagnostic workspace " })
    )
    map("n", "<leader>b", fzf.buffers, vim.tbl_extend("force", opts, { desc = "Switch buffers" }))
    map("n", "<leader>l", fzf.lgrep_curbuf, vim.tbl_extend("force", opts, { desc = "live grep" }))
    map("n", "<leader>L", fzf.live_grep, vim.tbl_extend("force", opts, { desc = "live grep" }))
    -- map("n", "<leader><leader>", fzf.live_grep, vim.tbl_extend("force", opts, { desc = "live grep" }))
    map("n", "<leader>t", fzf.tags, vim.tbl_extend("force", opts, { desc = "Search tags" }))
end

-- lsp keybindings
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local bufnr = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end


        local navic = require("nvim-navic")
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end

        local nmap = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end

        local nvmap = function(keys, func, desc)
            vim.keymap.set({ "n", "v" }, keys, func, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end

        -- 🔥 Inlay Hints Toggle (0.10+)
        if client.server_capabilities.inlayHintProvider
            and vim.lsp.inlay_hint then
            nmap(".h", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
            end, "Toggle Inlay Hints")
        end

        -- === Navigation ===
        nmap("gd", vim.lsp.buf.definition, "Goto Definition")
        nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")

        if not ok then
            nmap("gr", vim.lsp.buf.references, "Goto References")
        else
            nmap("gr", fzf.lsp_references, "Goto References")
        end

        nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
        nmap("gt", vim.lsp.buf.type_definition, "Goto Type Definition")
        nmap("gs", vim.lsp.buf.document_symbol, "Document Symbols")

        -- === Info ===
        nmap("K", vim.lsp.buf.hover, "Hover Docs")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- === Refactor ===
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        nvmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")

        -- === Diagnostics ===
        nmap("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        nmap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        nmap("<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
        nmap("<leader>dl", vim.diagnostic.setloclist, "Diagnostics → Location List")

        -- === Formatting (safe async) ===
        if client.server_capabilities.documentFormattingProvider then
            nmap("<leader>gf", function()
                vim.lsp.buf.format({
                    async = true,
                    filter = function(c)
                        return c.id == client.id
                    end,
                })
            end, "Format Document")
        end
    end,
})

local function is_ant_project()
    local build_file = io.open(ROOT_DIR .. "/build.xml")

    if build_file then
        build_file:close()
        return true
    else
        return false
    end
end

local function get_or_create_terminal()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local bt = vim.api.nvim_buf_get_option(buf, "buftype")
            if bt == "terminal" then
                return buf
            end
        end
    end

    vim.cmd("terminal")
    return vim.api.nvim_get_current_buf()
end

local function compile_and_run()
    local file_path = vim.fn.expand("%:p:h") -- Get the directory of the current file
    local file_name_ext, file_type = vim.fn.expand("%:t"), vim.bo.filetype
    local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")

    if file_type == "java" then
        if is_ant_project() then
            file_type = "ant"
        end
    end

    local term_buf = get_or_create_terminal()


    local command = ({
        cpp = string.format(
            "cd %s; clang++ --std=c++23 %s -o %s; ./%s",
            file_path,
            file_name_ext,
            file_name,
            file_name
        ),
        java = string.format("cd %s; javac %s; java %s", file_path, file_name_ext, file_name),
        c = string.format("cd %s; clang %s -o %s; ./%s", file_path, file_name_ext, file_name, file_name),
        python = string.format("cd %s; python %s", file_path, file_name_ext),
        rust = string.format("cd %s; cargo run", file_path),
        bash = string.format("cd %s; bash %s", file_path, file_name_ext),
        sh = string.format("cd %s; bash %s", file_path, file_name_ext),
        ant = string.format("cd %s; ant", ROOT_DIR),
    })[file_type]

    local term_ok, job_id = pcall(vim.api.nvim_buf_get_var, term_buf, "terminal_job_id")
    if not term_ok or not job_id then
        vim.api.nvim_set_current_buf(term_buf)
        job_id = vim.b.terminal_job_id
    end

    if command then
        print(command, job_id, term_buf)
        vim.fn.chansend(job_id, command .. "\n")
    else
        print("Unsupported file type.")
    end
end

-- run command
vim.keymap.set("n", "<leader>cr", compile_and_run, { desc = "Compile & Run" })

-- copy directory
vim.keymap.set("n", "<leader>cp", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    print("Copied directory: " .. dir)
end, { desc = "Copy file directory to clipboard" })

-- buffer switching
-- for i = 1, 9 do
-- 	vim.keymap.set("n", "<leader>" .. i, function()
-- 		vim.cmd("buffer " .. i)
-- 	end)
-- end
