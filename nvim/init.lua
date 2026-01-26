-- Neovim: simpel, transparant, geen bloat.
-- Tekst in, tekst uit. Config is Lua. Niks meer.

-- Core settings
require("set")
require("remap")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup(require("plugins"), {
  ui = { icons = {} },
  rocks = { enabled = false },
})
