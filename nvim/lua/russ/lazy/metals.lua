return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  ft = { "scala", "sbt" },
  opts = function()
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      -- JDK Metals uses to ANALYZE the project (compile, presentation compiler, BSP).
      -- adm-application's build.sbt rejects anything but Java 11, so we pin it here.
      javaHome = vim.fn.expand("~/.sdkman/candidates/java/11.0.31-tem"),
    }

    -- Metals itself was compiled with Java 17 and won't start on Java 11. We point
    -- the metals subprocess at Java 21 via JAVA_HOME, scoped to this LSP client only —
    -- your shell's JAVA_HOME (Java 11, for sbt) is untouched.
    metals_config.cmd_env = {
      JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/21.0.5-tem"),
    }

    metals_config.init_options.statusBarProvider = "off"

    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    metals_config.on_attach = function(client, bufnr)
      -- scalafmt (via Metals) owns formatting when .scalafmt.conf exists.
      -- Leave it on — unlike vtsls/eslint there's no second formatter to fight.
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
