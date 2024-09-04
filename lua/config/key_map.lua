local wk = require("which-key")

vim.g.mapleader = " "
-- common mappings
vim.keymap.set({ "i", "n" }, "<C-s>", "<cmd>w<CR>")                                         -- save file
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y')                                                -- copy selection
vim.keymap.set("n", "<leader>hc", "<cmd>nohlsearch<CR>", { noremap = true, silent = true }) -- Clear search highlighting
-- swap line up
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gc")
--swap line down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("v", "<A-Down>", ":m '<+1<CR>gv=gc")
-- code format
vim.keymap.set("n", "<leader>cf", function()
    vim.lsp.buf.format()
end)

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Escape terminal Mode
vim.api.nvim_set_keymap('t', '<Leader><ESC>', '<C-\\><C-n>', { noremap = true })

-- file operations mappings
wk.add({
    { "<leader>f",  group = "file" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
    { "<leader>fw", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep", mode = "n" },
})

-- Neotree mappings
local is_open = false
function ToggleNeotree()
    if is_open then
        vim.cmd("Neotree focus")
    else
        vim.cmd("Neotree reveal")
    end
    is_open = not is_open
end

wk.add({ "<leader>e", function() ToggleNeotree() end, desc = "Explorer", mode = "n" })
vim.keymap.set("n", "<c-n>", function()
    vim.cmd("Neotree close")
    is_open = not is_open
end)

-- code + lsp mappings
wk.add({
    { "<leader>ca", function() vim.lsp.buf.code_action() end,   desc = "Code Actions",      mode = "n" },
    { "<leader>ch", function() vim.lsp.buf.hover() end,         desc = "Hover Actions",     mode = "n" },
    { "<leader>cr", "<cmd>LspUI rename<cr>",                    desc = "Rename Symbol",     mode = "n" },
    { "<leader>ws", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols",  mode = "n" },
    { "<leader>Ws", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols", mode = "n" }
})
-- workspace symbols
-- vim.keymap.set("n", "<leader>ws", "<cmd>Trouble symbols toggle focus=true<cr>")

-- terminal
vim.keymap.set("t", "<A-i>", function()
    vim.cmd("ToggleTerm")
end)
vim.keymap.set("n", "<A-i>", function()
    vim.cmd("ToggleTerm direction=float")
end)
