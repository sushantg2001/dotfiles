-- load order matters: motion first, commands last
require 'keymaps.motion'
require 'keymaps.editing'
require 'keymaps.search'
require 'keymaps.lsp'
require 'keymaps.git'
require 'keymaps.ui'
require 'keymaps.tools'
require 'keymaps.commands' -- intent menus last, after all keymaps registered
