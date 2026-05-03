local map = vim.keymap.set

map({ 'n', 'i', 'v', 'o' }, '<A-q>', function() _G.smart_run 'ToggleTerm' end)
map('t', '<A-q>', function()
  -- Escape terminal mode, then run the smart command
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true), 'n', false)
  _G.smart_run 'ToggleTerm'
end)
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: focus left' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: focus right' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: focus down' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: focus up' })

map('n', '<C-x>', '<cmd>bd<cr>', { desc = 'Close buffer / editor' })
map('t', '<C-x>', '<cmd>ToggleTerm<cr>', { desc = 'Close terminal' })
