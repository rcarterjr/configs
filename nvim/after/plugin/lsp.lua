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
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

--[[
--
--
--
--
--
--
--
-- OLD LSP config
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.pyright.setup{
    capabilities = capabilities,
    on_attach = function ()
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
    end,
}

require'lspconfig'.tsserver.setup{}
require'lspconfig'.clangd.setup{}

-- COMPLETION CONFIGURATION
vim.opt.completeopt={"menu","menuone","noselect"} -- setting vim values

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    experimental = {
    -- new menu
    native_menu = false,

    -- I don't hate it
    ghost_text = true,
  },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = function(fallback)
          if cmp.visible() then
             cmp.select_next_item()
           else
             fallback()
           end
      end,
      ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
              cmp.select_prev_item()
          else
              fallback()
          end
    end,
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer', keyword_length = 3 }, --  keyword_length will wait for that num of chars before suggesting
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })
  
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --  capabilities = capabilities
 -- j}
 -- ]]
 
