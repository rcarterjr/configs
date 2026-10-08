-- experimental plugin -- delete if not using (and Twilight)
return {

  "folke/zen-mode.nvim",
  config = function()
    vim.keymap.set("n", "<leader>zz", function()
      require("zen-mode").setup {
        window = {
          width = 120,
          options = {}
        },
        plugins = {
          twilight = { enabled = false }
        }
      }
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
      ColorMyPencils()
    end)

    vim.keymap.set("n", "<leader>zZ", function()
      require("zen-mode").setup {
        window = {
          width = 120,
          options = {}
        },
        plugins = {
          twilight = { enabled = true }
        }
      }
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
      ColorMyPencils()
    end)
  end
}
