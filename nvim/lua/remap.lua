local map = vim.keymap.set

-- Centered scrolling
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Buffers
map("n", "<leader><leader>", "<C-^>", { desc = "Alternate Buffer" })
map("n", "<C-h>", "<cmd>bp<CR>", { desc = "Prev Buffer" })
map("n", "<C-l>", "<cmd>bn<CR>", { desc = "Next Buffer" })

-- Line bubbling
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })
map("n", "<C-j>", "<cmd>m .+1<CR>==", { desc = "Move Down" })
map("n", "<C-k>", "<cmd>m .-2<CR>==", { desc = "Move Up" })
map("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move Down" })
map("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move Up" })

-- Editing
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace Word" })

-- Toggles
map("n", "<leader>os", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle Spell" })

map("n", "<leader>od", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

-- File explorer
map("n", "-", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
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

-- Fast escape
map("i", "jk", "<Esc>")
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Rust Development
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format" })
map("n", "<leader>cb", "<cmd>!cargo build<CR>", { desc = "Cargo Build" })
map("n", "<leader>cr", "<cmd>!cargo run<CR>", { desc = "Cargo Run" })
map("n", "<leader>ct", "<cmd>!cargo test<CR>", { desc = "Cargo Test" })
map("n", "<leader>cc", "<cmd>!cargo check<CR>", { desc = "Cargo Check" })
map("n", "<leader>cl", "<cmd>!cargo clippy<CR>", { desc = "Cargo Clippy" })
