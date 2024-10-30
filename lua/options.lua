require "nvchad.options"

-- add yours here!
local o = vim.o
o.cursorlineopt = 'both' -- to enable cursorline!
o.relativenumber = true
o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4

-- background transparent
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("highlight Normal ctermbg=none guibg=none")
    end
})
