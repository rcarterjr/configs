-- This file can be loaded by calling `lua require('russ.packer')` from your init.vim

-- Only required if you have packer configured as `opt` (???)
vim.cmd [[packadd packer.nvim]]

-- After adding a plugi, run :PackerSync

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  -- use 'folke/tokyonight.nvim'
  -- use 'gruvbox-community/gruvbox'
  -- use 'rose-pine/neovim'
  -- use 'EdenEast/nightfox.nvim'
  --
  -- This is how Prime does it

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
                  vim.cmd('colorscheme rose-pine')
    end
  })

  -- <leader>zz
  use {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      }
    end
  }

  -- dims inactive portions of the code when in Zen mode
  use {
  "folke/twilight.nvim",
  config = function()
    require("twilight").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      }
    end
  }

  -- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,}

  use("nvim-treesitter/playground")
  use 'prettier/vim-prettier'

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
  -- https://github.com/lewis6991/gitsigns.nvim (other cool shortcuts)
   use 'lewis6991/gitsigns.nvim'

  -- https://github.com/numToStr/Comment.nvim
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }

 

  -- need to practice this one before i go live with it
  -- use 'tpope/vim-fugitive'

  -- adds the status bar to the bottom
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
 
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
    }

  -- pointless plugin <leader>fml

  use 'eandrju/cellular-automaton.nvim'
 
  -- kind of cool but is a little too distracting
  -- use "lukas-reineke/indent-blankline.nvim"

end)
