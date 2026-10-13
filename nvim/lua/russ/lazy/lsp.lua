return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "lua_ls",
        "eslint",
        "rust_analyzer",
      },
      -- `handlers` was removed in mason-lspconfig v2; it auto-enables every
      -- installed server unless excluded here. We use vtsls for TS/Vue, and
      -- ts_ls has formatting enabled which conflicts with ESLint style rules.
      automatic_enable = {
        exclude = { "ts_ls" },
      },
    })

    -- Buffers whose name is a plugin URI (diffview://, fugitive://) still look like real
    -- files to LSP auto-attach when buftype is empty (diffview stage-0 buffers); terraform-ls
    -- panics on such a didOpen URI. Skipping on_dir() blocks activation, on_dir(nil) leaves
    -- root resolution to each server's root_markers.
    vim.lsp.config("*", {
      root_dir = function(bufnr, on_dir)
        if vim.api.nvim_buf_get_name(bufnr):match("^%a[%w+.-]*://") then
          return
        end
        on_dir(nil)
      end,
    })

    local servers = {
      ['rust_analyzer'] = {
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
      },
      terraformls = {},
      -- ts_ls = {}, -- using vue's ts lsp for now
      -- eslint = {}, -- configured eslint below; can consolidate once it's working
      pyright = { -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
        settings = {
          python = {
            analysis = {
              --defaults
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "standard",
              --
              diagnosticSeverityOverrides = {
                reportUnusedImport = "none",
              }
            },
          },
        },
      }, -- todo
      ruff = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each", "snacks", "Snacks" },
            },
          },
        },
      }
    }

    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    for server, cfg in pairs(servers) do
      -- test both below
      -- cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
      cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities,
        cfg.capabilities or cmp_lsp.default_capabilities())

      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<cr>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      virtual_text = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
    -- IT's WORKING :)
    -- VUE ATTEMPT 1 in 0.11 --
    -- VUE ATTEMPT 1 in 0.11 --
    -- https://github.com/vuejs/language-tools/wiki/Neovim
    -- VUE ATTEMPT 1 in 0.11 --
    -- VUE ATTEMPT 1 in 0.11 --
    -- For Mason v1,
    -- local mason_registry = require('mason-registry')
    -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
    -- For Mason v2,
    local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
        '/vue-language-server' .. '/node_modules/@vue/language-server'
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      -- filetypes = { 'javascriptreact', 'typescriptreact', 'vue' },
      on_attach = function(client)
        -- prettier (when config exists) or eslint owns formatting; disable vtsls
        -- formatter to prevent it mangling quotes/style on fallback
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    }
    -- If you are not on most recent `nvim-lspconfig` or you want to override
    local vue_ls_config = {
      on_attach = function(client)
        -- vtsls + @vue/typescript-plugin handles definitions; disable here to prevent duplicate gd results
        client.server_capabilities.definitionProvider = false
      end,
      on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
          local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
          if #clients == 0 then
            vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
            command = 'typescript.tsserverRequest',
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
            local response = r and r.body
            -- TODO: handle error or response nil here, e.g. logging
            -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
            local response_data = { { id, response } }

            ---@diagnostic disable-next-line: param-type-mismatch
            client:notify('tsserver/response', response_data)
          end)
        end
      end,
    }

    -- nvim 0.11 or above
    --
    -- testing eslint
    vim.lsp.config("eslint", {
      settings = {
        workingDirectory = { mode = "auto" },
        -- reef uses eslint.config.js (flat config); depths/tide/etc use .eslintrc.js
        -- (legacy). With useFlatConfig = true, the LSP is a no-op for legacy
        -- packages (no eslint.config.js found), which is correct — they rely on
        -- the eslint CLI, not LSP fixAll, for style enforcement.
        -- auto-detect flat vs legacy config per working directory
        -- (reef uses eslint.config.js; tide/depths/etc use .eslintrc.js)
      },

      on_attach = function(client, bufnr)
        -- IMPORTANT: avoid fighting with Conform/Prettier formatting
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local augroup = vim.api.nvim_create_augroup("EslintFixAll", { clear = false })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'eslint' })[1]
            if not client then return end
            local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
            params.context = {
              only = { 'source.fixAll.eslint' },
              diagnostics = {},
              triggerKind = 1,
            }
            local result = client:request_sync('textDocument/codeAction', params, 1000, bufnr)
            if not result or not result.result or #result.result == 0 then return end
            for _, action in ipairs(result.result) do
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
              end
              if action.command then
                client:exec_cmd(action.command, { bufnr = bufnr })
              end
            end
          end,
        })
      end,
    })

    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.enable({ 'vtsls', 'vue_ls', 'eslint' })
  end,
}
