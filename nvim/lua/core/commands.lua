-- lua/core/commands.lua
-- All user-defined commands that should appear in :Telescope commands
-- Wrappers around common operations for discoverability

local cmd = vim.api.nvim_create_user_command

-- tabs
cmd('TabNew', 'tabnew', { desc = 'New tab page' })
cmd('TabClose', 'tabclose', { desc = 'Close tab page' })
cmd('TabNext', 'tabnext', { desc = 'Next tab' })
cmd('TabPrev', 'tabprev', { desc = 'Prev tab' })
cmd('SplitV', 'vsplit', { desc = 'Vertical split' })
cmd('SplitH', 'split', { desc = 'Horizontal split' })
cmd('Format', function() require('conform').format { async = true } end, { desc = 'Format current buffer' })
cmd('LspRestart', 'LspRestart', { desc = 'Restart LSP server' })
cmd(
  'Lazygit',
  function() require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true }):toggle() end,
  { desc = 'Open Lazygit' }
)
