-- =============================================================================
-- EDITING
-- Everything that changes text.
-- =============================================================================

local map = vim.keymap.set

map({ 'i', 'c' }, '<C-e>', '<Del>', { desc = 'Delete' })
map({ 'i', 'c' }, '<C-b>', '<C-o>db', { desc = 'Delete backward to start of word' })

map('n', 'U', '<C-r>', { desc = 'Redo' })
map('n', '<A-u>', '<cmd>Telescope undo<cr>', { desc = 'Telescope: Visual Undo Tree' })
map('i', '<C-u>', '<Cmd>undo<CR>', { desc = 'Undo' })
-- Redo in Insert Mode using the obscure Unit Separator (\31)
map('i', '\31', '<Cmd>redo<CR>', { desc = 'Redo via Ctrl+Shift+U' })

map({ 'n', 'v' }, 'gy', '"+y', { desc = 'Clipboard yank motion' })
map('n', 'gyy', '"+yy', { desc = 'Clipboard yank line' })
map('n', 'gY', '"+Y', { desc = 'Clipboard yank to EOL' })
map('n', '<C-y>', '<cmd>%y+<cr>', { desc = 'Yank file to clipboard' })
map('v', '<C-y>', '"+y', { desc = 'Yank selection to clipboard' })
map('i', '<C-y>', '<cmd>norm "+yy<cr>', { desc = 'Yank line to clipboard' })
map('c', '<C-y>', '<cmd>norm "+yy<cr>', { desc = 'Yank line to clipboard' })

map({ 'n', 'v' }, 'gd', '"+d', { desc = 'Clipboard delete motion' })
map('n', 'gdd', '"+dd', { desc = 'Clipboard delete line' })
map('n', 'gD', '"+D', { desc = 'Clipboard delete to EOL' })
map('n', '<C-d>', '<cmd>%d+<cr>', { desc = 'Delete file to clipboard' })
map('v', '<C-d>', '"+d', { desc = 'Delete selection to clipboard' })
map('i', '<C-d>', '<cmd>norm "+dd<cr>', { desc = 'Delete line to clipboard' })

map({ 'n', 'v' }, 'gx', '"+x', { desc = 'Clipboard cut char' })
map({ 'n', 'v' }, 'gX', '"+X', { desc = 'Clipboard cut char backward' })

map({ 'n', 'v' }, 'gp', '"+p', { desc = 'Clipboard paste after' })
map({ 'n', 'v' }, 'gP', '"+P', { desc = 'Clipboard paste before' })
map({ 'n', 'v' }, 'zp', '"0p', { desc = 'Last yank paste after' })
map({ 'n', 'v' }, 'zP', '"0P', { desc = 'Last yank paste before' })

map('n', '<C-i>', 'i<Space><Esc>', { desc = 'Insert space before cursor' })
map('n', '<C-a>', 'a<Space><Esc>', { desc = 'Insert space after cursor' })
