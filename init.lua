vim.g.mapleader = " "

local opt = vim.opt

opt.syntax = "true"
opt.number = true
opt.tabstop = 4
opt.softtabstop = 4
opt.relativenumber = true
opt.autoindent = true
opt.shiftwidth = 4
opt.termguicolors = true
opt.ttyfast = true
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.expandtab = true

require("config.lazy")
require("config.key_map")
