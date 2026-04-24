-- globals first (must be before lazy)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- core modules
require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'core.lazy'   -- bootstraps lazy and loads plugins/
