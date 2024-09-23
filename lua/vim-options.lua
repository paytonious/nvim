vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set colorcolumn=80")
vim.cmd("set cursorline")
vim.cmd("set number relativenumber")

-- Mapleader key
vim.g.mapleader = " "

-- Key remapping
vim.cmd("map <M-j> <C-e>", { noremap = true, silent = true })
vim.cmd("map <M-k> <C-y>", { noremap = true, silent = true })

