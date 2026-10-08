return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    local ensure_installed = {
      "bash", "c", "csv", "diff", "dockerfile", "gitignore", "glsl", "html",
      "ini", "java", "javascript", "json", "lua", "markdown",
      "markdown_inline", "nginx", "properties", "python", "query",
      "requirements", "rust", "scala", "sql", "terraform", "toml",
      "tsx", "typescript", "vim", "vimdoc", "vue", "yaml",
    }

    local available = {}
    for _, lang in ipairs(ts.get_available()) do
      available[lang] = true
    end

    local installed = {}
    local pending = {}

    local function start(buf)
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.treesitter.start, buf)
      end
    end

    -- Refresh the installed set and highlight buffers that were opened before
    -- their parser finished installing.
    local function refresh()
      installed = {}
      for _, lang in ipairs(ts.get_installed("parsers")) do
        installed[lang] = true
      end
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if lang and installed[lang] then
            start(buf)
          end
        end
      end
    end

    refresh()
    for _, lang in ipairs(ensure_installed) do
      pending[lang] = true
    end
    ts.install(ensure_installed):await(vim.schedule_wrap(refresh))

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        if installed[lang] then
          start(args.buf)
        elseif available[lang] and not pending[lang] then
          pending[lang] = true
          ts.install(lang):await(vim.schedule_wrap(refresh))
        end
      end,
    })
  end,
}
