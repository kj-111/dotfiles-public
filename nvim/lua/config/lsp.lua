local M = {}

function M.setup()
  -- LSP capabilities (Neovim 0.11+)
  local has_completion, mini_completion = pcall(require, "mini.completion")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if has_completion then
    capabilities = vim.tbl_deep_extend("force", capabilities, mini_completion.get_lsp_capabilities())
  end

  -- Server configuration (Neovim 0.11+ native API)
  -- NOTE: Java wordt geconfigureerd via ftplugin/java.lua met nvim-jdtls

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

  -- XML (voor pom.xml)
  vim.lsp.config("lemminx", {
    cmd = { "lemminx" },
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
    root_markers = { "pom.xml", ".git" },
    capabilities = capabilities,
  })

  -- LSP servers niet automatisch starten (behalve lemminx voor pom.xml)
  -- Per-taal toggles in ftplugin zijn beter (zie ftplugin/java.lua)
  vim.lsp.enable({ "lemminx" })

  -- Keymaps (on attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Inlay hints
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

      -- Neovim 0.11+ heeft standaard LSP keybindings (grn, gra, grr, etc.)
      -- We overschrijven sommige om mini.pick te gebruiken ipv quickfix
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
  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = {
      "jdtls",
      "java-debug-adapter",
      "java-test",
      "lemminx",
      "python-lsp-server",
      "typescript-language-server",
    },
  })
end

return M
