return {
  "sindrets/diffview.nvim",
  config = function()
    local actions = require("diffview.actions")

    -- Defaults everywhere except the four maps that collided with mine.
    -- `["<lhs>"] = false` deletes a default; list entries add a replacement.
    require("diffview").setup({
      keymaps = {
        view = {
          -- <leader>e is Snacks.explorer
          ["<leader>e"] = false,
          { "n", "<leader>df", actions.focus_files,             { desc = "Bring focus to the file panel" } },
          -- <leader>ca is vim.lsp.buf.code_action
          ["<leader>ca"] = false,
          { "n", "<leader>cc", actions.conflict_choose("all"),  { desc = "Choose all the versions of a conflict" } },
        },
        file_panel = {
          -- - is Oil (s still stages/unstages)
          ["-"] = false,
          -- <c-f> is tmux-sessionizer
          ["<c-f>"] = false,
          { "n", "<c-d>",      actions.scroll_view(0.25),   { desc = "Scroll the view down" } },
          { "n", "<c-u>",      actions.scroll_view(-0.25),  { desc = "Scroll the view up" } },
          ["<leader>e"] = false,
          { "n", "<leader>df", actions.focus_files,         { desc = "Bring focus to the file panel" } },
        },
        file_history_panel = {
          -- <c-f> is tmux-sessionizer
          ["<c-f>"] = false,
          { "n", "<c-d>",      actions.scroll_view(0.25),   { desc = "Scroll the view down" } },
          { "n", "<c-u>",      actions.scroll_view(-0.25),  { desc = "Scroll the view up" } },
          -- <leader>e is Snacks.explorer
          ["<leader>e"] = false,
          { "n", "<leader>df", actions.focus_files,         { desc = "Bring focus to the file panel" } },
        },
      },
    })

    -- Global entry points, on the <leader>h prefix freed up from gitsigns
    vim.keymap.set("n", "<leader>hd", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: diff the working tree" })
    vim.keymap.set("n", "<leader>hc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: close" })
    vim.keymap.set("n", "<leader>hH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: branch history" })
    vim.keymap.set("n", "<leader>hh", function()
      local file = vim.fn.expand("%:p")
      if file == "" then
        vim.cmd("DiffviewFileHistory")
      else
        vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(file))
      end
    end, { desc = "Diffview: history of the current file" })
  end,
}
