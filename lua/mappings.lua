require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- In your keybindings file or init.lua
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
