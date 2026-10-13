-- Walk upward from `dir`, return true if a prettier config exists before a .git root
local function project_has_prettier(dir)
  local configs = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs",
    ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml",
    "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs",
  }
  local current = dir
  while current and current ~= "" do
    for _, name in ipairs(configs) do
      if vim.uv.fs_stat(current .. "/" .. name) then
        return true
      end
    end
    -- Stop at the git root — don't climb into ~/ or global config dirs
    if vim.uv.fs_stat(current .. "/.git") then
      return false
    end
    local parent = vim.fs.dirname(current)
    if parent == current then break end
    current = parent
  end
  return false
end

-- Filetypes that should only be formatted when the project has a prettier config.
-- ESLint fixAll (lsp.lua BufWritePre) handles style for projects without prettier.
local prettier_fts = { typescript = true, javascript = true, vue = true, typescriptreact = true, javascriptreact = true }

require("conform").setup({
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    -- For web filetypes: skip conform entirely if the project has no prettier config.
    -- Returning nil means conform does nothing — ESLint fixAll owns the save.
    if prettier_fts[vim.bo[bufnr].filetype] then
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local dirname = vim.fn.fnamemodify(filepath, ':h')
      if not project_has_prettier(dirname) then
        return
      end
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    rust = { "rustfmt" },
    python = {
      -- To fix auto-fixable lint errors.
      -- "ruff_fix",
      -- To run the Ruff formatter.
      "ruff_format",
      -- To organize the imports.
      "ruff_organize_imports",
    },
    lua = { "stylua" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

-- disable formatting on save
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

-- enable formatting on save
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
