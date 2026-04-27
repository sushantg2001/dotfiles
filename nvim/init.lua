-- =============================================================================
-- ENTRY POINT
-- Works on: WSL, Windows, Linux
-- Order matters: globals  options  keymaps  autocmds  plugins
-- =============================================================================

-- globals must be set before lazy.nvim loads
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.g.is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
vim.g.is_wsl = vim.fn.has 'wsl' == 1
vim.g.is_linux = vim.fn.has 'unix' == 1 and not vim.g.is_wsl and not vim.g.is_windows
vim.g.is_mac = vim.fn.has 'mac' == 1

require 'core.options'
require 'core.autocmds'
require 'core.lazy' -- plugins load here
require 'keymaps' -- all keymaps load after plugins
