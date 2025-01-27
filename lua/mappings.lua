require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("t", "<ESC><ESC>", "<C-\\><C-n>", { silent = true })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- Shrink/Expand splits
map('n', '<A-Up>', ':resize -2<CR>', opts)             -- Shrink horizontally (up)
map('n', '<A-Down>', ':resize +2<CR>', opts)           -- Expand horizontally (down)
map('n', '<A-Left>', ':vertical resize -2<CR>', opts)  -- Shrink vertically (left)
map('n', '<A-Right>', ':vertical resize +2<CR>', opts) -- Expand vertically (right)

vim.api.nvim_set_keymap("n", "<Leader>fw", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<Leader>fW",
  "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
  { noremap = true, silent = true }
)
map("n", "<Leader>Rn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true })

map("n", "<Leader>ca", function()
  vim.lsp.buf.code_action()
end)

local inlay_hint_enabled = true

map("n", ".h", function()
  inlay_hint_enabled = not inlay_hint_enabled
  vim.lsp.inlay_hint.enable(inlay_hint_enabled)
  print("Toggled Inlay Hints")
end, { desc = "toggle inlay hints" })

function lsp_bindings()
  -- Helper function to simplify keymap definitions
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
  nmap("<leader>de", vim.diagnostic.open_float, "[E]rror Details")
  nmap("<leader>dq", vim.diagnostic.setloclist, "[Q]uickfix Diagnostics List")

  -- Format the buffer
  nmap("<leader>gf", vim.lsp.buf.format, "[F]ormat Document")
end

vim.api.nvim_create_autocmd("LspAttach", { callback = lsp_bindings })


function compile_and_run_cpp()
  -- Get the current file name
  local file_name = vim.fn.expand("%:t") -- Get the file name with extension
  local file_base = vim.fn.expand("%:r") -- Get the file name without extension

  -- Check if the file is a C++ file
  if vim.bo.filetype == "cpp" then
    -- Open a terminal and run the command
    vim.cmd("term") -- Open a terminal in a split window
    vim.fn.chansend(vim.b.terminal_job_id,
      string.format("clang++ --std=c++23 %s -o %s.exe && %s.exe\n", file_name, file_base, file_base))
  else
    print("This shortcut works only for C++ files.")
  end
end

-- Map the shortcut
vim.api.nvim_set_keymap("n", "<leader>cr", ":lua compile_and_run_cpp()<CR>", { noremap = true, silent = true })
