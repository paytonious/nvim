vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set colorcolumn=80")
vim.cmd("set cursorline")
vim.cmd("set number relativenumber")
vim.cmd("set laststatus=2")
vim.cmd("set statusline+=%f")
vim.o.signcolumn = "yes"


-- Mapleader key
vim.g.mapleader = " "

-- Key remapping
vim.cmd("map <M-j> <C-e>", { noremap = true, silent = true })
vim.cmd("map <M-k> <C-y>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  return "<Esc>"
end, { expr = true, silent = true, desc = "Clear search highlights on Esc" })

