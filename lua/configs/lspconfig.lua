-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "jdtls", "pylsp", "gopls", "ruby_lsp" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.denols.setup {
  on_attach = nvlsp.on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  capabilities = nvlsp.capabilities,
}

local function get_fallback_flags()
  local filetype = vim.bo.filetype
  if filetype == "c" then
    return { "--std=c11" }
  elseif filetype == "cpp" then
    return { "--std=c++20" }
  else
    return {}
  end
end

lspconfig.clangd.setup {
  capabilities = nvlsp.capabilities,
  init_options = {
    fallbackFlags = get_fallback_flags(),
  },
}

lspconfig.lua_ls.setup {
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  on_attach = nvlsp.on_attach,
  root_dir = function()
    return false
  end,
}

-- Improved method descriptions
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
