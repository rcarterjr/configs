-- ** NEED TO UNCOMMENT COLORS IN packer.lua **
--
--
-- vim.g.tokyonight_transparent_sidebar = true
-- vim.g.tokyonight_transparent = true
-- vim.g.background = "dark"
-- vim.cmd("colorscheme tokyonight")

-- vim.cmd("colorscheme gruvbox")

-- https://github.com/EdenEast/nightfox.nvim
-- vim.cmd("colorscheme nightfox") -- good one
-- vim.cmd("colorscheme terafox")
-- vim.cmd("colorscheme duskfox")
-- vim.cmd("colorscheme carbonfox")
-- vim.cmd("colorscheme nordfox")

-- https://github.com/rose-pine/neovim for more settings
-- vim.cmd("colorscheme rose-pine")

require("rose-pine").setup({
    disable_background = true -- Prime set this true
})

function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- treat this as colorscheme, just make sure colors 
-- are install in packer.lua
ColorMyPencils("rose-pine")
