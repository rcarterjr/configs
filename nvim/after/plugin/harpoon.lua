local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file) -- add file to harpoon
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu) -- CTRL e, show menu

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end) -- maybe remap to something more intuitive ?
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
