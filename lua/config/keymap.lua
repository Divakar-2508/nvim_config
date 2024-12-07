vim.g.mapleader = ' '
--clear highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", ":bd<CR>", { silent = true })

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

-- Function to set up keybindings after LSP attaches
function lsp_bindings()
    -- Helper function to simplify keymap definitions
    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
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

