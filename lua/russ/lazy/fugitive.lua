return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gS", vim.cmd.Git, { desc = "Git Status (fugitive)" })
  end,
}
