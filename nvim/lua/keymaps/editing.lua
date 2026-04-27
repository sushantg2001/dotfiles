-- =============================================================================
-- EDITING
-- Everything that changes text.
-- =============================================================================

local map = vim.keymap.set

map('n', 'U', '<C-r>', { desc = 'Redo' })

map({ 'n', 'v' }, 'gy', '"+y', { desc = 'Clipboard yank motion' })
map('n', 'gyy', '"+yy', { desc = 'Clipboard yank line' })
map('n', 'gY', '"+Y', { desc = 'Clipboard yank to EOL' })
map('n', '<C-y>', '<cmd>%y+<cr>', { desc = 'Yank file to clipboard' })
map('v', '<C-y>', '"+y', { desc = 'Yank selection to clipboard' })
map('i', '<C-y>', '<cmd>norm "+yy<cr>', { desc = 'Yank line to clipboard' })

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
map('n', '<C-p>', '<cmd>%d _<cr>"+P', { desc = 'Replace file with clipboard' })
map('v', '<C-p>', '"+p', { desc = 'Replace selection with clipboard' })
map('i', '<C-p>', '<C-r>+', { desc = 'Paste from clipboard' })

map('n', '"', '"0', { desc = 'Fixed register a' })
map('n', "'", '"', { desc = 'Register prefix' })

map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('v', '<Tab>', '>gv', { desc = 'Indent selection' })
map('v', '<S-Tab>', '<gv', { desc = 'De-indent selection' })

map('n', '<CR>', 'o<Esc>', { desc = 'Add line below' })
map('n', '<S-CR>', 'O<Esc>', { desc = 'Add line above' })
map({ 'n', 'i', 'v' }, '<C-CR>', '<cmd>w<cr><esc>', { desc = 'Save file' })

map('n', '<Tab>', '>>', { desc = 'Indent line' })
map('n', '<S-Tab>', '<<', { desc = 'De-indent line' })
