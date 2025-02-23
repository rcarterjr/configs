require("russ.set")
require("russ.remap")
require("russ.lazy_init")

local augroup = vim.api.nvim_create_augroup
local RussGroup = augroup("RussGroup", {})

local autocmd = vim.api.nvim_create_autocmd


autocmd("LspAttach", {
  group = RussGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })                           -- "in (n)ormal mode, map "K" to vim.lsp.bug.hover() only for this ([0]) buffer" -- run :help <func name> to learn more
    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })                     -- when over a function name, (g)o to (d)efinition
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })                -- when over an object, (g)o to (t)ype
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })                 -- when over an object, (g)o to (i)mplementation -- especially useful for Golang
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })           -- go to next error (diagnostic)
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = 0 })           -- go to previous error (diagnostic)
    vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { buffer = 0 })          -- go to previous error (diagnostic)
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })   -- diagnostics list, via Telescope
    vim.keymap.set("n", "<leader>R", "<cmd>Telescope lsp_references<cr>", { buffer = 0 }) -- shows all references of something inside a project via Telescope
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })                  -- smart rename variable/func/etc -- it can replace in other files (if it does, run :wa to save those changes)
    vim.keymap.set("n", "<leader>c", "<Plug>(copilot#Accept)", { buffer = 0 })            -- leader (c)omplete copilot suggestion
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })            -- server dependent - can do useful things like autoimport or organize imports(delete unused ones)
    -- experimental
    vim.keymap.set("n", "<leader>p", "<cmd>Prettier<cr>", { buffer = 0 })                 -- leader (p)rettier - format
    vim.keymap.set("n", "<leader>F", "<cmd>EslintFixAll<cr>", { buffer = 0 })             -- (F)ormat -- EslintFixAll

    vim.diagnostic.config({
      virtual_text = true
    })

    autocmd("BufWritePre", {
      buffer = e.buf,
      callback = function()
        vim.lsp.buf.format { async = false, id = e.data.client_id }
      end,
    })
  end
})
