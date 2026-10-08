-- https://github.com/nvim-lualine/lualine.nvim
-- https://github.com/cmiran/nvim/blob/master/lua/cool_bassi/lualine.lua <=== gitsigns integration
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = "+ ",
        modified = "~ ",
        removed = "- "
      },

      cond = hide_in_width,

      source = function()
        local gitsigns_status = vim.b.gitsigns_status_dict

        if gitsigns_status then
          return {
            added = gitsigns_status.added,
            modified = gitsigns_status.changed,
            removed = gitsigns_status.removed
          }
        end
      end,

    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = ' ', right = ' ' },
        section_separators = { left = ' ', right = '● ' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },

      --[[

  +-------------------------------------------------+

  | A | B | C                             X | Y | Z |

  +-------------------------------------------------+

  --]]

      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'filename', path = 2 }, 'branch', diff },
        lualine_c = { 'diagnostics' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },

      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end,
}
