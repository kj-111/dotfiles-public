local M = {}

-- Helper: verzamel alle keybindings voor picker
function M.pick_all_keybindings(pick, clue)
  local items = {}
  local sources = {
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.builtin_completion(),
  }
  for _, source in ipairs(sources) do
    for _, c in ipairs(source) do
      if c.desc then
        table.insert(items, string.format("%-20s %s", c.keys, c.desc))
      end
    end
  end
  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
    if map.desc then
      table.insert(items, string.format("%-20s %s", map.lhs, map.desc))
    end
  end
  pick.start({ source = { items = items, name = "Alle Keybindings" } })
end

function M.setup()
  -- ============================================================
  -- Editing: ai, comment, surround, cursorword
  -- ============================================================
  require("mini.ai").setup({ n_lines = 500 })
  require("mini.comment").setup()
  -- Surround mappings (s ipv gs). Gebruik `cl` voor originele `s` (substitute)
  require("mini.surround").setup({
    mappings = {
      add = "sa",
      delete = "sd",
      replace = "sr",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      update_n_lines = "sn",
    },
  })
  -- require("mini.completion").setup()  -- uitgeschakeld (leren zonder suggesties)
  require("mini.cursorword").setup()

  -- ============================================================
  -- UI: statusline, tabline
  -- ============================================================
  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
          "%<",
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=",
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
    },
  })
  require("mini.tabline").setup()

  -- ============================================================
  -- Git: diff, git
  -- ============================================================
  require("mini.diff").setup({
    view = { style = "sign" },  -- Git signs in gutter
  })
  require("mini.git").setup()  -- Git branch in statusline

  -- ============================================================
  -- Bestanden & Navigatie
  -- ============================================================
  require("mini.extra").setup()
  require("mini.files").setup({
    options = { permanent_delete = false },  -- Veiligere deletes
    mappings = {
      go_in_plus = "l",  -- Open bestand EN sluit mini.files
      go_in = "L",       -- Open bestand, houd mini.files open
    },
  })

  -- Icons (met devicons mock)
  require("mini.icons").setup()
  require("mini.icons").mock_nvim_web_devicons()

  -- ============================================================
  -- Animatie (Neovide-achtig)
  -- ============================================================
  require("mini.animate").setup({
    cursor = { enable = false },
    scroll = {
      enable = true,
      timing = require("mini.animate").gen_timing.quadratic({ easing = "in-out", duration = 150, unit = "total" }),
      subscroll = require("mini.animate").gen_subscroll.equal({ max_output_steps = 60 }),
    },
    resize = { enable = false },
    open = { enable = false },
    close = { enable = false },
  })

  -- ============================================================
  -- Picker (gecentreerd venster)
  -- ============================================================
  local pick = require("mini.pick")
  pick.setup({
    window = {
      config = function()
        local h = math.floor(0.618 * vim.o.lines)
        local w = math.floor(0.8 * vim.o.columns)
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

  -- ============================================================
  -- Hipatterns (TODO/FIXME/hex kleuren)
  -- ============================================================
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
      todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
      note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
      caution = { pattern = "%f[%w]()CAUTION()%f[%W]", group = "MiniHipatternsFixme" },
      jean = { pattern = "%f[%w]()JEAN()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  -- ============================================================
  -- Clue (which-key vervanger)
  -- ============================================================
  local clue = require("mini.clue")
  clue.setup({
    window = { config = { width = 50, anchor = "NW", row = 1 } },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "i", keys = "<C-x>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "s" },
      { mode = "x", keys = "s" },
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
      { mode = "n", keys = "<Leader>c", desc = "+Code" },
      { mode = "n", keys = "<Leader>q", desc = "+Quickfix" },
      { mode = "n", keys = "<Leader>j", desc = "+Java" },
    },
  })

  -- ============================================================
  -- Keymaps
  -- ============================================================
  local map = vim.keymap.set
  local extra = require("mini.extra").pickers

  map("n", "<leader>sf", pick.builtin.files, { desc = "Bestanden" })
  map("n", "<leader>sg", pick.builtin.grep_live, { desc = "Grep" })
  map("n", "<leader>sb", pick.builtin.buffers, { desc = "Buffers" })
  map("n", "<leader>sh", pick.builtin.help, { desc = "Help" })
  map("n", "<leader>st", extra.hipatterns, { desc = "Hipatterns" })
  map("n", "<leader>sd", extra.diagnostic, { desc = "Diagnostics" })
  map("n", "<leader>sm", extra.marks, { desc = "Marks" })
  map("n", "<leader>sl", extra.buf_lines, { desc = "Buffer Regels" })
  map("n", "<leader>so", extra.oldfiles, { desc = "Recente Bestanden" })
  map("n", "<leader>sH", extra.git_hunks, { desc = "Git Hunks" })
  map("n", "<leader>sk", extra.keymaps, { desc = "Keymaps" })
  map("n", "<leader>sn", function()
    pick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config") } })
  end, { desc = "Nvim Config" })
  map("n", "<leader>sa", function()
    M.pick_all_keybindings(pick, clue)
  end, { desc = "Alle Keybindings" })

  -- ============================================================
  -- Nord thema aanpassingen
  -- ============================================================
  local hl = vim.api.nvim_set_hl
  hl(0, "MiniStatuslineModeNormal", { fg = "#2E3440", bg = "#81A1C1", bold = true })
  hl(0, "MiniStatuslineModeCommand", { fg = "#2E3440", bg = "#5E81AC", bold = true })
  hl(0, "MiniPickMatchCurrent", { bg = "#4C566A", bold = true })
  hl(0, "MiniPickMatchMarked", { bg = "#A3BE8C", fg = "#2E3440", bold = true })
end

return M
