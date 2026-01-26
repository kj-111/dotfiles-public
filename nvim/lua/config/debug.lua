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
  map("n", "<leader>dq", dap.terminate, { desc = "Debug [q]uit" })

  -- Java DAP wordt geconfigureerd via ftplugin/java.lua (jdtls.setup_dap)
end

return M
