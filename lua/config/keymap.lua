vim.g.mapleader = " "

--clear highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- vim.keymap.set("n", "cc", "ggVGy")

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
		fzf.lsp_workspace_symbols,
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
		fzf.diagnostics_document,
		vim.tbl_extend("force", opts, { desc = "Search diagnostic workspace " })
	)
	map("n", "<leader>b", fzf.buffers, vim.tbl_extend("force", opts, { desc = "Switch buffers" }))
	map("n", "<leader>l", fzf.live_grep, vim.tbl_extend("force", opts, { desc = "live grep" }))
	map("n", "<leader>t", fzf.tags, vim.tbl_extend("force", opts, { desc = "Search tags" }))
end

-- lsp keybindings
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- Helper for mapping keys
		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		end

		-- Inlay hints setup
		if client.server_capabilities.inlayHintProvider then
			print("Inlay hints are supported. Use .h to toggle.")

			local inlay_hints_enabled = false
			nmap(".h", function()
				inlay_hints_enabled = not inlay_hints_enabled
				vim.lsp.inlay_hint.enable(bufnr, inlay_hints_enabled)
				print(inlay_hints_enabled and "Inlay Hints enabled" or "Inlay Hints disabled")
			end, "Toggle Inlay Hints")
		else
			print("Inlay hints are not supported by the attached LSP server.")
		end

		-- === LSP Keybindings ===
		nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("gs", vim.lsp.buf.document_symbol, "[G]oto [S]ymbols")
		nmap("gt", vim.lsp.buf.type_definition, "[T]ype Definition")
		nmap("K", vim.lsp.buf.hover, "Hover Documentation")
		nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
		nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Diagnostics
		nmap("[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
		nmap("]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
		nmap("<leader>e", vim.diagnostic.open_float, "[E]rror Details")
		nmap("<leader>q", vim.diagnostic.setloclist, "[Q]uickfix Diagnostics List")

		-- Format
		nmap("<leader>gf", vim.lsp.buf.format, "[F]ormat Document")
	end,
})

local function compile_and_run()
	local file_path = vim.fn.expand("%:p:h") -- Get the directory of the current file
	local file_name_ext, file_type = vim.fn.expand("%:t"), vim.bo.filetype
	local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")

	local term_bufnr = nil
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buftype == "terminal" then
			term_bufnr = bufnr
			break
		end
	end

	if not term_bufnr then
		vim.cmd("term")
		term_bufnr = vim.api.nvim_get_current_buf()
	else
		vim.api.nvim_set_current_buf(term_bufnr)
	end

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
	})[file_type]

	if command then
		vim.fn.chansend(vim.api.nvim_buf_get_var(term_bufnr, "terminal_job_id"), command .. "\n")
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
