-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scrolling & Wrapping
vim.opt.scrolloff = 10
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.smoothscroll = true

-- Folds (Treesitter-based)
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Persistence
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.confirm = true

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.inccommand = "split"

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Visual
vim.opt.virtualedit = "block"
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  leadmultispace = "│   ",  -- Indent guides (4 spaces)
}

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable netrw (using mini.files)
vim.g.loaded_netrw = 1

-- Autocmds
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight-yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = augroup("help-fullscreen"),
  callback = function()
    vim.cmd("wincmd o")
  end,
})

-- Command abbreviations
vim.cmd("cnoreabbrev term vert term")
