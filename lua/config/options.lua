vim.opt.fillchars = { eob = " " } -- Replace tildes with spaces on empty lines
vim.opt.termguicolors = true
-- Set tab width to 4 spaces
vim.opt.tabstop = 4 -- Number of spaces a tab character represents
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of indentation
vim.opt.softtabstop = 4 -- Number of spaces that a Tab key feels like when editing
vim.opt.expandtab = true -- Convert tabs to spaces

-- Enable line numbers
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Enable line wrapping
vim.opt.wrap = false -- Disable line wrapping

-- Enable search highlighting
vim.opt.hlsearch = true -- Highlight all matches of the last search
vim.opt.incsearch = true -- Show matches as you type

-- Enable smart case for searching
vim.opt.smartcase = true -- Case-sensitive search only if there is an uppercase letter

vim.opt.scrolloff = 8 -- Keep 8 lines above and below the cursor when scrolling

-- Enable clipboard support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for copy/paste

-- Enable hidden buffers
vim.opt.hidden = true -- Allow switching between buffers without saving

-- Highlight current line
vim.opt.cursorline = true -- Highlight the current line

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" }) -- Also applies to unfocused splits
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- Floating windows
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" }) -- Sign column (gutter)
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" }) -- Empty buffer lines

vim.api.nvim_set_hl(0, "LineNr", { bg = "none" }) -- Empty buffer lines
vim.cmd([[
  autocmd ColorScheme * highlight LineNr guibg=NONE
  autocmd ColorScheme * highlight SignColumn guibg=NONE
]])

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- Floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "gray" }) -- Floating window borders
