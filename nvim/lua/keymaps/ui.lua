-- =============================================================================
-- UI KEYMAPS
-- splits, buffers, terminal, explorer, tabs, notifications
-- =============================================================================

local map = vim.keymap.set
map('n', '<A-=>', '<cmd>resize +2<cr>', { desc = 'Increase split height' })
map('n', '<A-->', '<cmd>resize -2<cr>', { desc = 'Decrease split height' })

map('n', '<F14>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer tab (C+])' })
map('n', '<F13>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer tab (C+[)' })
for i = 1, 9 do
  map('n', '<C-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', { desc = 'Go to buffer ' .. i })
end
map('n', '<A-h>', '<C-w>h', { desc = 'Focus left split' })
map('n', '<A-j>', '<C-w>j', { desc = 'Focus down split' })
map('n', '<A-k>', '<C-w>k', { desc = 'Focus up split' })
map('n', '<A-l>', '<C-w>l', { desc = 'Focus right split' })
map('n', '<A-]>', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '<A-[', '<cmd>tabprev<cr>', { desc = 'Prev tab' })
-- =============================================================================
-- ZEN MODE
-- =============================================================================
map({ 'n', 'i', 'v' }, '<A-\\>', function()
  local ok, zen = pcall(require, 'zen-mode')
  if ok then
    zen.toggle()
  else
    vim.notify('zen-mode.nvim not installed', vim.log.levels.WARN)
  end
end, { desc = 'Toggle zen mode' })
