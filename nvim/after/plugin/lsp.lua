---- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()


lsp.ensure_installed({
    "tsserver",
    "eslint",
    "pyright",
    "sumneko_lua",
    -- "rust_analyzer"
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- apparently tab completing is bad - we'll see if I can do without
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0}) -- "in (n)ormal mode, map "K" to vim.lsp.bug.hover() only for this ([0]) buffer" -- run :help <func name> to learn more
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0}) -- when over a function name, (g)o to (d)efinition
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0}) -- when over an object, (g)o to (t)ype
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0}) -- when over an object, (g)o to (i)mplementation -- especially useful for Golang
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0}) -- go to next error (diagnostic)
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0}) -- go to previous error (diagnostic)
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0}) -- diagnostics list, via Telescope
    vim.keymap.set("n", "<leader>R", "<cmd>Telescope lsp_references<cr>", {buffer=0}) -- shows all references of something inside a project via Telescope
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0}) -- smart rename variable/func/etc -- it can replace in other files (if it does, run :wa to save those changes)
    vim.keymap.set("n", "<leader>c", "<Plug>(copilot#Accept)", {buffer=0}) -- leader (c)omplete copilot suggestion
    --BROKEN :( vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_actions, {buffer=0}) -- server dependent - can do useful things like autoimport or organize imports(delete unused ones)
    vim.keymap.set("n", "<leader>p", "<cmd>Prettier<cr>", { buffer = 0 }) -- leader (p)rettier - format

end)

-- prettier on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
    command = 'silent! Prettier',--EslintFixAll',
    group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
