return {
  -- LSP (Neovim 0.11+ native vim.lsp.config API)
  -- LSP progress: j-hui/fidget.nvim (verwijderd, te veel noise)
  {
    "williamboman/mason.nvim",
    opts = {},
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("config.lsp").setup()
    end,
  },

  -- DAP (lazy loaded on keypress)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>ds", desc = "Debug Start" },
      { "<leader>db", desc = "Debug Breakpoint" },
    },
    config = function()
      require("config.debug").setup()
    end,
  },

  -- Theme
  {
    "nordtheme/vim",
    name = "nord",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
      -- Match terminal background
      local hl = vim.api.nvim_set_hl
      hl(0, "Normal", { bg = "NONE" })
      hl(0, "NormalFloat", { bg = "NONE" })
      hl(0, "SignColumn", { bg = "NONE" })
      hl(0, "EndOfBuffer", { bg = "NONE" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "bash", "java", "rust", "toml", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Mini.nvim (core editing suite)
  {
    "echasnovski/mini.nvim",
    config = function()
      require("config.mini").setup()
    end,
  },

  -- Dodona
  {
    "kj-111/dodona.nvim",
    config = function()
      require("dodona").setup()
    end,
  },
}
