vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO figure these out
-- set tabstop=2 softtabstop=2
-- set shiftwidth=2
-- set expandtab
-- set smartindent
-- set number
-- set relativenumber

-- indentation stuff
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 8

-- set highlight on search
vim.o.hlsearch = false

-- relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- enable mouse mode
vim.o.mouse = "a"

-- sync clipboard between OS and neovim
vim.o.clipboard = "unnamedplus"

-- enable breakindent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive search unless \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- not all terminals support this but most modern ones do
vim.o.termguicolors = true

-- highlight line under cursor, this helps with navigation
vim.opt.cursorline = true

-- keep 8 lines above and below cursor when scrolling
vim.opt.scrolloff = 8

