vim.g.mapleader = " "
-- common mappings
vim.keymap.set({ "i", "n" }, "<C-s>", "<cmd>w<CR>") -- save file
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y') -- copy selection
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

-- telescope mapping
-- file finder
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- word search
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>")

-- neotree mappings
local is_open = false

function ToggleNeotree()
	if is_open then
		vim.cmd("Neotree close")
	else
		vim.cmd("Neotree reveal")
	end
	is_open = not is_open
end

-- open and close explorer
vim.keymap.set("n", "<leader>e", function()
	ToggleNeotree()
end)

-- lsp, code mapping
-- code actions
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end)
-- hover actions
vim.keymap.set("n", "<leader>ch", function()
	vim.lsp.buf.hover()
end)
