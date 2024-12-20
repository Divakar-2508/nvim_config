
vim.opt.fillchars = { eob = " " }  -- Replace tildes with spaces on empty lines

-- Set tab width to 4 spaces
vim.opt.tabstop = 4        -- Number of spaces a tab character represents
vim.opt.shiftwidth = 4     -- Number of spaces to use for each step of indentation
vim.opt.softtabstop = 4    -- Number of spaces that a Tab key feels like when editing
vim.opt.expandtab = true   -- Convert tabs to spaces

-- Enable line numbers
vim.opt.number = true      -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers

-- Enable line wrapping
vim.opt.wrap = false       -- Disable line wrapping

-- Enable search highlighting
vim.opt.hlsearch = true    -- Highlight all matches of the last search
vim.opt.incsearch = true   -- Show matches as you type

-- Enable smart case for searching
vim.opt.smartcase = true   -- Case-sensitive search only if there is an uppercase letter

-- Enable line numbers, tab settings, and spaces
vim.opt.number = true      -- Display line numbers
vim.opt.relativenumber = true  -- Display relative line numbers
vim.opt.scrolloff = 8      -- Keep 8 lines above and below the cursor when scrolling

-- Enable clipboard support
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard for copy/paste

-- Enable hidden buffers
vim.opt.hidden = true      -- Allow switching between buffers without saving

-- Enable wrapping of long lines
vim.opt.wrap = false       -- Disable wrapping of long lines

-- Highlight current line
vim.opt.cursorline = true -- Highlight the current line

-- Enable clipboard support for copy-pasting
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard

