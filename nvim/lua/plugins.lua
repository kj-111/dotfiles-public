return {
  -- LSP (Neovim 0.11+ native vim.lsp.config API)
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
      local hl = vim.api.nvim_set_hl

      -- Nord kleuren aanpassen (na plugins laden)
      vim.schedule(function()
        local nord_bg = "#2E3440"
        hl(0, "NormalFloat", { bg = nord_bg })
        hl(0, "FloatBorder", { bg = nord_bg, fg = "#4C566A" })
      end)
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "java",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("config.textobjects").setup()
    end,
  },

  -- Markdown rendering
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "quarto", "rmd" },
    config = function()
      require("config.markview").setup()
    end,
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

  -- TMC (TestMyCode) voor MOOC Java
  {
    dir = "~/temple/opensource/tmc.nvim",
    dependencies = { "echasnovski/mini.nvim" },
    config = function()
      require("tmc").setup({
        course_name = "java-programming-i",
        download_dir = "~/temple/vaults/obsidian-jean/code/java-practice/helsinki-mooc/exercices/java1",
      })
    end,
  },

  -- Java (nvim-jdtls voor betere Java support)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

}
