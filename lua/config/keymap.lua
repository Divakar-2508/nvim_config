vim.g.mapleader = " "
--clear highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- vim.keymap.set("n", "cc", "ggVGy")

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
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
--[[ vim.keymap.set("n", "<M-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" }) ]]

-- inlay_hints
local inlay_hints = false
local function toggle_inlay_hints()
	local bufnr = vim.api.nvim_get_current_buf()

	-- Ensure LSP is attached
	local clients = vim.lsp.buf_get_clients(bufnr)
	if #clients == 0 then
		print("No LSP server attached to the current buffer")
		return
	end

	-- Check if inlay hint provider is available for the current LSP client
	local capabilities = clients[1].server_capabilities
	if capabilities.inlayHintProvider then
		-- Toggle inlay hint
		inlay_hints = not inlay_hints
		vim.lsp.inlay_hint.enable(inlay_hints)
		if inlay_hints then
			print("Inlay Hints enabled")
		else
			print("Inlay Hints Disabled")
		end
	else
		print("Inlay hints are not supported by the current LSP server")
	end
end

vim.keymap.set("n", ".h", function()
	toggle_inlay_hints()
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local bufnr = event.buf
		local clients = vim.lsp.buf_get_clients(bufnr)
		if #clients == 0 then
			return
		end

		local capabilities = clients[1].server_capabilities
		if capabilities.inlayHintProvider then
			print("Inlay hints are supported. Use .h to toggle.")
		else
			print("Inlay hints are not supported by the attached LSP server.")
		end
	end,
})

function lsp_bindings()
	local nmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- LSP-related keybindings
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Diagnostics keybindings
	nmap("[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
	nmap("]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
	nmap("<leader>e", vim.diagnostic.open_float, "[E]rror Details")
	nmap("<leader>q", vim.diagnostic.setloclist, "[Q]uickfix Diagnostics List")

	-- Format the buffer
	nmap("<leader>gf", vim.lsp.buf.format, "[F]ormat Document")
end

vim.api.nvim_create_autocmd("LspAttach", { callback = lsp_bindings })

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
	})[file_type]

	if command then
		vim.fn.chansend(vim.api.nvim_buf_get_var(term_bufnr, "terminal_job_id"), command .. "\n")
	else
		print("Unsupported file type.")
	end
end

vim.keymap.set("n", "<leader>cr", compile_and_run, { desc = "Compile & Run" })
