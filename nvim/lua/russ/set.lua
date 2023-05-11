-- vim.opt.guicursor = ""
vim.g.mapleader = " "

-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- allows us to move highlight lines up and down like VSC*de
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append to line above
vim.keymap.set("n", "J", "mzJ`z")
-- CTRL + D  the cursor will move down a page and center the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- CTRL + U  the cursor will move down a page and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keeps cursor centered when jumping to next/previous search result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- "greatest remap ever" -- maintains copy buffer when pasting or somethin
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- highlights all instance of a word and allows you to change them all at once
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartindent = true

vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.termguicolors = true

vim.opt.colorcolumn = "80"
