local map = vim.keymap.set

map('n', '<C-x>', '<cmd>bd<cr>', { desc = 'Close buffer / editor' })
map('t', '<C-x>', '<cmd>ToggleTerm<cr>', { desc = 'Close terminal' })
map({ 'n', 'i', 'v', 't' }, '<A-q>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
