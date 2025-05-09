---@module 'lazy'

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true, hidden = true },
    gitbrowse = {},
    indent = { enabled = false }, -- shows column for scope
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false }, -- smooth scroll
    statuscolumn = { enabled = true },
    words = { enabled = false },  -- highlight words
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end,                desc = "Smart Find Files" },
    { "<leader>/",       function() Snacks.picker.grep() end,                 desc = "Grep" },
    { "<leader>e",       function() Snacks.explorer() end,                    desc = "File Explorer" },
    -- find
    { "<leader>fb",      function() Snacks.picker.buffers() end,              desc = "Buffers" },
    { "<leader>ff",      function() Snacks.picker.files() end,                desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end,            desc = "Find Git Files" },
    { "<leader>fp",      function() Snacks.picker.projects() end,             desc = "Projects" },
    { "<leader>fr",      function() Snacks.picker.recent() end,               desc = "Recent" },
    -- git
    { "<leader>gb",      function() Snacks.picker.git_branches() end,         desc = "Git Branches" },
    { "<leader>gl",      function() Snacks.picker.git_log() end,              desc = "Git Log" },
    { "<leader>gL",      function() Snacks.picker.git_log_line() end,         desc = "Git Log Line" },
    { "<leader>gs",      function() Snacks.picker.git_status() end,           desc = "Git Status" },
    { "<leader>gd",      function() Snacks.picker.git_diff() end,             desc = "Git Diff (Hunks)" },
    { "<leader>gf",      function() Snacks.picker.git_log_file() end,         desc = "Git Log File" },
    -- Grep
    { "<leader>sb",      function() Snacks.picker.lines() end,                desc = "Buffer Lines" },
    { "<leader>sB",      function() Snacks.picker.grep_buffers() end,         desc = "Grep Open Buffers" },
    { "<leader>sg",      function() Snacks.picker.grep() end,                 desc = "Grep" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end,            desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>sb",      function() Snacks.picker.lines() end,                desc = "Buffer Lines" },
    { "<leader>sd",      function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
    { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,   desc = "Buffer Diagnostics" },
    { "<leader>sk",      function() Snacks.picker.keymaps() end,              desc = "Keymaps" },
    { "<leader>su",      function() Snacks.picker.undo() end,                 desc = "Undo History" },
    { "<leader>uC",      function() Snacks.picker.colorschemes() end,         desc = "Colorschemes" },
    -- LSP
    { "gd",              function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,       nowait = true,                     desc = "References" },
    { "gI",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- Other
    { "<leader>.",       function() Snacks.scratch() end,                     desc = "Toggle Scratch Buffer" },
    { "<leader>S",       function() Snacks.scratch.select() end,              desc = "Select Scratch Buffer" },
    { "<leader>n",       function() Snacks.notifier.show_history() end,       desc = "Notification History" },
    { "<leader>cR",      function() Snacks.rename.rename_file() end,          desc = "Rename File" },
    { "<leader>gB",      function() Snacks.gitbrowse() end,                   desc = "Git Browse",               mode = { "n", "v" } },
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        -- Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
