local M = {}

function M.setup()
  -- Textobjects (met treesitter support)
  local ai = require("mini.ai")
  local ts = ai.gen_spec.treesitter
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      f = ts({ a = "@function.outer", i = "@function.inner" }),
      l = ts({ a = "@loop.outer", i = "@loop.inner" }),
      o = ts({ a = "@conditional.outer", i = "@conditional.inner" }),
      c = ts({ a = "@class.outer", i = "@class.inner" }),
      a = ts({ a = "@parameter.outer", i = "@parameter.inner" }),
    },
  })
  require("mini.surround").setup()
  require("mini.comment").setup()
  require("mini.completion").setup()
  require("mini.cursorword").setup()
  require("mini.statusline").setup()
  require("mini.tabline").setup()
  require("mini.diff").setup({
    view = { style = "sign" },  -- Git signs in gutter
  })
  require("mini.extra").setup()
  require("mini.files").setup({
    options = { permanent_delete = false },  -- Safer deletes
    mappings = {
      go_in_plus = "l",  -- Open bestand EN sluit mini.files
      go_in = "L",       -- Open bestand, houd mini.files open
    },
  })

  -- Icons (with devicons mock)
  require("mini.icons").setup()
  require("mini.icons").mock_nvim_web_devicons()

  -- Pick (centered window, golden ratio)
  local pick = require("mini.pick")
  pick.setup({
    window = {
      config = function()
        local h = math.floor(0.618 * vim.o.lines)
        local w = math.floor(0.618 * vim.o.columns)
        return {
          anchor = "NW",
          height = h,
          width = w,
          row = math.floor(0.5 * (vim.o.lines - h)),
          col = math.floor(0.5 * (vim.o.columns - w)),
        }
      end,
    },
  })
  vim.ui.select = pick.ui_select

  -- Hipatterns (TODO/FIXME/hex colors)
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
      todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
      note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
      caution = { pattern = "%f[%w]()CAUTION()%f[%W]", group = "MiniHipatternsFixme" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  -- Clue (which-key replacement)
  local clue = require("mini.clue")
  clue.setup({
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "i", keys = "<C-x>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "]" },
      { mode = "n", keys = "[" },
    },
    clues = {
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<Leader>s", desc = "+Search" },
      { mode = "n", keys = "<Leader>o", desc = "+Options" },
      { mode = "n", keys = "<Leader>d", desc = "+Debug" },
      { mode = "n", keys = "<Leader>c", desc = "+Cargo" },
      { mode = "n", keys = "<Leader>q", desc = "+Quickfix" },
    },
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>sf", pick.builtin.files, { desc = "Find File" })
  vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "Live Grep" })
  vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "Help" })
  vim.keymap.set("n", "<leader>st", function()
    require("mini.extra").pickers.hipatterns()
  end, { desc = "TODOs" })

  -- Nord theme adjustments
  local hl = vim.api.nvim_set_hl
  hl(0, "MiniStatuslineModeNormal", { fg = "#2E3440", bg = "#81A1C1", bold = true })
  hl(0, "MiniStatuslineModeCommand", { fg = "#2E3440", bg = "#5E81AC", bold = true })
  hl(0, "MiniPickMatchCurrent", { bg = "#4C566A", bold = true })
  hl(0, "MiniPickMatchMarked", { bg = "#A3BE8C", fg = "#2E3440", bold = true })
end

return M
