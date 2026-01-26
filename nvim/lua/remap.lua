local map = vim.keymap.set

-- Buffers
map("n", "<leader><leader>", "<C-^>", { desc = "Alternate Buffer" })
map("n", "<C-h>", "<cmd>bp<CR>", { desc = "Prev Buffer" })
map("n", "<C-l>", "<cmd>bn<CR>", { desc = "Next Buffer" })

-- Line bubbling
map("n", "<C-j>", "<cmd>m .+1<CR>==", { desc = "Move Down" })
map("n", "<C-k>", "<cmd>m .-2<CR>==", { desc = "Move Up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })
map("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move Down" })
map("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move Up" })

-- Editing
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Toggles
map("n", "<leader>os", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle Spell" })
map("n", "<leader>ox", function()
  local line = vim.api.nvim_get_current_line()
  if line:match("%[ %]") then
    local timestamp = os.date("%Y-%m-%d %H:%M")
    line = line:gsub("%[ %]", "[x]", 1) .. " -- " .. timestamp
  elseif line:match("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1):gsub(" %-%- %d%d%d%d%-%d%d%-%d%d %d%d:%d%d$", "")
  end
  vim.api.nvim_set_current_line(line)
end, { desc = "Toggle Checkbox" })

-- File explorer
map("n", "-", function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
  end
end, { desc = "Files" })

-- Quickfix
map("n", "<leader>qd", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end, { desc = "Quickfix (diagnostics)" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open Quickfix" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close Quickfix" })
map("n", "]q", "<cmd>cnext<CR>")
map("n", "[q", "<cmd>cprev<CR>")

-- Diagnostics
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next Diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev Diagnostic" })

-- Save
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save" })

-- Fast escape
map("i", "jk", "<Esc>")
map("n", "<Esc>", "<cmd>nohlsearch<Bar>echon ''<CR>")
map("t", "jk", "<C-\\><C-n>")
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Code
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace Word" })
map("n", "<leader>cd", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
map("n", "<leader>ci", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Muis scroll uit (animatie conflicteert)
map({ "n", "v", "i" }, "<ScrollWheelUp>", "<Nop>")
map({ "n", "v", "i" }, "<ScrollWheelDown>", "<Nop>")

-- Java keymaps zijn in ftplugin/java.lua
