require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight Normal ctermbg=none guibg=none")
  end
})
