-- This file can be loaded by calling `lua require('russ.packer')` from your init.vim

-- Only required if you have packer configured as `opt` (???)
vim.cmd [[packadd packer.nvim]]

-- After adding a plugin, run :PackerSync

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Colorschemes
  use 'folke/tokyonight.nvim'
  use 'gruvbox-community/gruvbox'
  use 'rose-pine/neovim'

  use 'prettier/vim-prettier'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'github/copilot.vim'

  use 'theprimeagen/harpoon'

  use 'mbbill/undotree'

  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required
    {'williamboman/mason.nvim'},           -- Optional
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'saadparwaiz1/cmp_luasnip'}, -- Optional
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  }
}

  -- Adds git diff gutter next to line number like VS*ode
  -- You can jump between hunks with [c and ]c. You can preview, stage, and undo hunks with <leader>hp, <leader>hs, and <leader>hu respectively
  use 'airblade/vim-gitgutter'

  use 'vim-airline/vim-airline' -- adds the status bar to the bottom

  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
    }

end)
