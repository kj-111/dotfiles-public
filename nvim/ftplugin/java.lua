-- Java ftplugin met nvim-jdtls
local jdtls = require("jdtls")
local mason = vim.fn.stdpath("data") .. "/mason/packages"

-- Debug bundles
local bundles = {}
vim.list_extend(bundles, vim.fn.glob(mason .. "/java-debug-adapter/extension/server/*.jar", true, true))
vim.list_extend(bundles, vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true, true))

-- Workspace directory (voorkomt herindexeren)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_completion, mini_completion = pcall(require, "mini.completion")
if has_completion then
  capabilities = vim.tbl_deep_extend("force", capabilities, mini_completion.get_lsp_capabilities())
end

-- Config
local config = {
  cmd = {
    "jdtls",
    "-data", workspace_dir,
  },
  root_dir = vim.fs.root(0, { "pom.xml", "build.gradle", ".git" }),
  capabilities = capabilities,

  settings = {
    java = {
      -- Build
      configuration = { updateBuildConfiguration = "interactive" },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },

      -- Code lens
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },

      -- Completion
      completion = {
        enabled = true,
        guessMethodArguments = true,
        postfix = { enabled = true },
      },

      -- Code generation
      codeGeneration = {
        hashCodeEquals = { useInstanceof = true },
        toString = { codeStyle = "STRING_BUILDER" },
        useBlocks = true,
      },

      -- Inlay hints
      inlayHints = {
        parameterNames = { enabled = "all" },
      },
    },
  },

  init_options = {
    bundles = bundles,
  },

  on_attach = function(client, bufnr)
    -- Setup DAP na attach
    jdtls.setup_dap({ hotcodereplace = "auto" })

    -- Auto format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("java-format-" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- Keymaps
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Java: " .. desc })
    end

    -- [o]rganize
    map("<leader>jo", jdtls.organize_imports, "[o]rganize imports")

    -- Refactoring: extract [v]ariable, [c]onstant, [m]ethod
    map("<leader>jv", jdtls.extract_variable, "extract [v]ariable")
    map("<leader>jc", jdtls.extract_constant, "extract [c]onstant")
    vim.keymap.set("v", "<leader>jm", function()
      jdtls.extract_method(true)
    end, { buffer = bufnr, desc = "Java: extract [m]ethod (visual)" })

    -- Testing: [t]est class, test [n]earest
    map("<leader>jt", jdtls.test_class, "[t]est class")
    map("<leader>jn", jdtls.test_nearest_method, "test [n]earest method")

    -- Maven: [b]uild, [r]un
    map("<leader>jb", "<cmd>!mvn compile -q<CR>", "[b]uild (mvn compile)")
    map("<leader>jr", function()
      vim.cmd("split | terminal mvn compile exec:java -q")
    end, "[r]un (mvn exec:java)")

  end,
}

-- Toggle jdtls (standaard uit)
vim.keymap.set("n", "<leader>jl", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })
  if #clients > 0 then
    vim.lsp.stop_client(clients[1].id)
    vim.notify("jdtls stopped", vim.log.levels.INFO)
  else
    jdtls.start_or_attach(config)
    vim.notify("jdtls started", vim.log.levels.INFO)
  end
end, { buffer = true, desc = "Java: toggle [l]sp (jdtls)" })
