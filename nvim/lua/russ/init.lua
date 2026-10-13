require("russ.set")
require("russ.remap")
require("russ.lazy_init")
require("russ.formatters")

local augroup = vim.api.nvim_create_augroup
local RussGroup = augroup("RussGroup", {})

local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
  group = RussGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })                  -- "in (n)ormal mode, map "K" to vim.lsp.bug.hover() only for this ([0]) buffer" -- run :help <func name> to learn more
    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })                     -- when over a function name, (g)o to (d)efinition
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })       -- when over an object, (g)o to (t)ype
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })        -- when over an object, (g)o to (i)mplementation -- especially useful for Golang
    vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end,
      { buffer = 0 })                                                           -- go to next error (diagnostic)
    vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end,
      { buffer = 0 })                                                           -- go to previous error (diagnostic)
    vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { buffer = 0 }) -- go to previous error (diagnostic)
    vim.keymap.set("n", "<leader>dl", function() Snacks.picker.diagnostics() end, { buffer = 0 })
    vim.keymap.set("n", "<leader>R", function() Snacks.picker.lsp_references() end, { buffer = 0 })
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })       -- smart rename variable/func/etc -- it can replace in other files (if it does, run :wa to save those changes)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 }) -- server dependent - can do useful things like autoimport or organize imports(delete unused ones)
  end
})


-- This will auto update the txt in nvim when claude applies changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = RussGroup,
  pattern = "*",
  callback = function()
    -- mode() reports "n" inside the cmdline window (q: / q/), where :checktime
    -- raises E11. getcmdwintype() is the only reliable way to detect it.
    if vim.fn.getcmdwintype() ~= "" or vim.fn.mode() == "c" then
      return
    end
    pcall(vim.cmd.checktime)
  end,
})
