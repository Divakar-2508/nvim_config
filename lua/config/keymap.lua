vim.g.mapleader = ' '
--clear highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })

local inlay_hints = false
-- Function to toggle inlay hints
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

-- Bind .h to toggle inlay hints in normal mode
vim.keymap.set('n', '.h', function() 
    toggle_inlay_hints()
end, { noremap = true, silent = true })

-- Setup LspAttach to handle LSP server readiness
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf
    local clients = vim.lsp.buf_get_clients(bufnr)
    if #clients == 0 then
      return
    end

    -- Check if the LSP server supports inlay hints
    local capabilities = clients[1].server_capabilities
    if capabilities.inlayHintProvider then
      print("Inlay hints are supported. Use .h to toggle.")
    else
      print("Inlay hints are not supported by the attached LSP server.")
    end
  end,
})


