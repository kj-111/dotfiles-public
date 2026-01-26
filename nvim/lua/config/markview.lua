local M = {}

local nord = {
  red = "#BF616A",
  orange = "#D08770",
  yellow = "#EBCB8B",
  green = "#A3BE8C",
  purple = "#B48EAD",
  cyan = "#88C0D0",
  blue = "#81A1C1",
  bg_dark = "#2E3440",
  bg_light = "#3B4252",
  fg_dim = "#D8DEE9",
}

local function setup_highlights()
  local hl = vim.api.nvim_set_hl

  -- Headings
  hl(0, "MarkviewHeading1", { fg = nord.red, bold = true })
  hl(0, "MarkviewHeading2", { fg = nord.orange, bold = true })
  hl(0, "MarkviewHeading3", { fg = nord.yellow, bold = true })
  hl(0, "MarkviewHeading4", { fg = nord.green, bold = true })
  hl(0, "MarkviewHeading5", { fg = nord.cyan, bold = true })
  hl(0, "MarkviewHeading6", { fg = nord.purple, bold = true })

  -- Code
  hl(0, "MarkviewCode", { bg = nord.bg_dark })
  hl(0, "MarkviewInlineCode", { fg = nord.yellow, bg = nord.bg_light })

  -- Checkboxes
  hl(0, "MarkviewCheckboxChecked", { fg = nord.green })
  hl(0, "MarkviewCheckboxUnchecked", { fg = nord.fg_dim })

  -- Links
  hl(0, "MarkviewHyperlink", { fg = nord.blue, underline = true })

  -- Tables
  hl(0, "MarkviewTableBorder", { fg = nord.cyan })

  -- Callouts
  hl(0, "MarkviewCalloutNote", { fg = nord.blue })
  hl(0, "MarkviewCalloutTip", { fg = nord.green })
  hl(0, "MarkviewCalloutImportant", { fg = nord.purple })
  hl(0, "MarkviewCalloutWarning", { fg = nord.yellow })
  hl(0, "MarkviewCalloutCaution", { fg = nord.red })
end

function M.setup()
  require("markview").setup({
    markdown = {
      headings = {
        heading_1 = { style = "icon", icon = "󰼏 ", hl = "MarkviewHeading1" },
        heading_2 = { style = "icon", icon = "󰎨 ", hl = "MarkviewHeading2" },
        heading_3 = { style = "icon", icon = "󰼑 ", hl = "MarkviewHeading3" },
        heading_4 = { style = "icon", icon = "󰎲 ", hl = "MarkviewHeading4" },
        heading_5 = { style = "icon", icon = "󰼓 ", hl = "MarkviewHeading5" },
        heading_6 = { style = "icon", icon = "󰎴 ", hl = "MarkviewHeading6" },
      },
      code_blocks = {
        style = "block",
        hl = "MarkviewCode",
      },
      block_quotes = {
        ["NOTE"] = { hl = "MarkviewCalloutNote", icon = "󰋽", title = true },
        ["TIP"] = { hl = "MarkviewCalloutTip", icon = "", title = true },
        ["IMPORTANT"] = { hl = "MarkviewCalloutImportant", icon = "", title = true },
        ["WARNING"] = { hl = "MarkviewCalloutWarning", icon = "", title = true },
        ["CAUTION"] = { hl = "MarkviewCalloutCaution", icon = "󰳦", title = true },
      },
    },
    markdown_inline = {
      checkboxes = {
        checked = { text = "󰗠", hl = "MarkviewCheckboxChecked" },
        unchecked = { text = "󰄰", hl = "MarkviewCheckboxUnchecked" },
      },
    },
  })

  setup_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("MarkviewNordHL", { clear = true }),
    callback = setup_highlights,
  })
end

return M
