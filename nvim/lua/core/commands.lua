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

local function smart_resize(delta)
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype

  if ft == 'neo-tree' then
    -- Sidebars: Resize width
    vim.cmd('vertical resize ' .. (delta > 0 and '+' or '-') .. math.abs(delta))
  elseif bt == 'terminal' then
    -- Terminals (usually bottom): Resize height
    vim.cmd('resize ' .. (delta > 0 and '+' or '-') .. math.abs(delta))
  else
    -- Standard Editor: Resize both to expand/shrink "outward"
    vim.cmd('vertical resize ' .. (delta > 0 and '+' or '-') .. math.abs(delta))
    vim.cmd('resize ' .. (delta > 0 and '+' or '-') .. math.abs(delta))
  end
end
vim.api.nvim_create_user_command('ResizeIncrease', function() smart_resize(2) end, { desc = 'Increase window size based on context' })
vim.api.nvim_create_user_command('ResizeDecrease', function() smart_resize(-2) end, { desc = 'Decrease window size based on context' })
