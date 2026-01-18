local M = {}

function M.setup()
  -- LSP capabilities (Neovim 0.11+)
  local has_completion, mini_completion = pcall(require, "mini.completion")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if has_completion then
    capabilities = vim.tbl_deep_extend("force", capabilities, mini_completion.get_lsp_capabilities())
  end

  -- Server configuration (Neovim 0.11+ native API)
  -- NOTE: vim.lsp.config/enable zijn experimentele APIs
  -- FALLBACK: Als dit breekt, installeer "neovim/nvim-lspconfig" en gebruik:
  --   require("lspconfig").rust_analyzer.setup({ capabilities = capabilities })
  vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
        procMacro = { enable = true },
      },
    },
  })

  -- Java (met debug bundles via Mason)
  local mason = vim.fn.stdpath("data") .. "/mason/packages"
  local bundles = {}
  vim.list_extend(bundles, vim.fn.glob(mason .. "/java-debug-adapter/extension/server/*.jar", true, true))
  vim.list_extend(bundles, vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true, true))

  vim.lsp.config("jdtls", {
    cmd = { "jdtls" },
    filetypes = { "java" },
    root_markers = { "pom.xml", "build.gradle", ".git" },
    capabilities = capabilities,
    init_options = { bundles = bundles },
  })

  -- Python
  vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
    capabilities = capabilities,
  })

  -- TypeScript/JavaScript
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
    capabilities = capabilities,
  })

  -- LSP servers niet automatisch starten (gebruik <leader>ol om aan te zetten)
  -- vim.lsp.enable({ "rust_analyzer", "jdtls", "pylsp", "ts_ls" })

  -- Toggle LSP (globaal, altijd beschikbaar)
  local servers = { "rust_analyzer", "jdtls", "pylsp", "ts_ls" }
  vim.keymap.set("n", "<leader>ol", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
      end
      vim.notify("LSP Stopped", vim.log.levels.INFO)
    else
      vim.lsp.enable(servers)
      vim.notify("LSP Started", vim.log.levels.INFO)
    end
  end, { desc = "Toggle LSP" })

  -- Keymaps (on attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Neovim 0.11+ has default LSP keybindings (grn, gra, grr, etc.)
      -- We override some to use mini.pick instead of quickfix
      local has_extra, extra = pcall(require, "mini.extra")
      if has_extra then
        map("grr", function() extra.pickers.lsp({ scope = "references" }) end, "References")
        map("gri", function() extra.pickers.lsp({ scope = "implementation" }) end, "Implementation")
        map("grd", function() extra.pickers.lsp({ scope = "definition" }) end, "Definition")
        map("gro", function() extra.pickers.lsp({ scope = "document_symbol" }) end, "Outline")
        map("grt", function() extra.pickers.lsp({ scope = "type_definition" }) end, "Type Definition")
      end
    end,
  })

  -- Diagnostics
  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = true,
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
    } or {},
    virtual_text = true,
  })

  -- Mason (tool installer)
  -- rust-analyzer komt via rustup, jdtls via Mason
  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = {
      "codelldb",
      "jdtls",
      "java-debug-adapter",
      "java-test",
      "python-lsp-server",
      "typescript-language-server",
    },
  })
end

return M
