local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()

  -- Auto open/close UI
  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close

  -- Keymaps
  local map = vim.keymap.set
  map("n", "<leader>ds", dap.continue, { desc = "Debug Start" })
  map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
  map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
  map("n", "<leader>dt", dap.step_out, { desc = "Step Out" })
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
  map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Condition: "))
  end, { desc = "Conditional Breakpoint" })
  map("n", "<leader>du", dapui.toggle, { desc = "Debug UI" })

  -- Rust adapter (codelldb via Mason)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.rust = {
    {
      name = "Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        -- Zoek target/debug binary
        local cwd = vim.fn.getcwd()
        local name = vim.fn.fnamemodify(cwd, ":t")
        local default = cwd .. "/target/debug/" .. name
        return vim.fn.input("Executable: ", default, "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }

  -- Java adapter (via jdtls)
  -- jdtls registreert automatisch dap.adapters.java wanneer debug bundles geladen zijn
  -- Configuratie wordt door jdtls gegenereerd, maar we voegen een fallback toe
  dap.configurations.java = {
    {
      name = "Launch Main",
      type = "java",
      request = "launch",
      mainClass = "",
    },
    {
      name = "Attach to Process",
      type = "java",
      request = "attach",
      hostName = "localhost",
      port = 5005,
    },
  }
end

return M
