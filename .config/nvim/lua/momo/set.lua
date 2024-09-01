-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- setting tabs to 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- setting really long undos
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- highlighting search incrementally
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- ensure good colors
vim.opt.termguicolors = true

-- top/ bottom part of the code never has less than 8 lines while scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- faster updates
vim.opt.updatetime = 50

-- setting the leader key
vim.g.mapleader = " "
