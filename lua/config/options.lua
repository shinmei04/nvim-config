-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use absolute line numbers in editing windows.
vim.opt.number = true
vim.opt.relativenumber = false

-- Keep English spell checking, but skip Japanese and other CJK text.
vim.opt.spelllang = { "en", "cjk" }
