-- =============================================================================
-- CORE KEYMAPS
-- Plugin-specific keymaps live inside each plugin's own file.
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
-- GENERAL
-- =============================================================================

-- clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- diagnostic quickfix list
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- better up/down on wrapped lines
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- =============================================================================
-- SPLITS
-- =============================================================================

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left split' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right split' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower split' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper split' })

map('n', '<leader>sv', '<C-w>v',  { desc = '[S]plit [V]ertical' })
map('n', '<leader>sh', '<C-w>s',  { desc = '[S]plit [H]orizontal' })
map('n', '<leader>se', '<C-w>=',  { desc = '[S]plit [E]qual size' })
map('n', '<leader>sx', '<cmd>close<CR>', { desc = '[S]plit [X] close' })

-- =============================================================================
-- BUFFERS
-- =============================================================================

map('n', '<S-l>', '<cmd>bnext<CR>',     { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
map('n', '<leader>bd', '<cmd>bd<CR>',   { desc = '[B]uffer [D]elete' })
map('n', '<C-^>', '<C-^>',              { desc = 'Toggle last two buffers' })

-- =============================================================================
-- TERMINAL
-- =============================================================================

-- exit terminal mode with Esc Esc
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- =============================================================================
-- EDITING
-- =============================================================================

-- move selected lines up/down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- keep cursor centred when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centred)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centred)' })

-- keep cursor centred when cycling search results
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- paste without losing register content
map('v', '<leader>p', '"_dP', { desc = 'Paste without overwriting register' })

-- delete without yanking
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

-- indent and stay in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- =============================================================================
-- QUICKFIX
-- =============================================================================

map('n', '<leader>co', '<cmd>copen<CR>',  { desc = '[C]quickfix [O]pen' })
map('n', '<leader>cc', '<cmd>cclose<CR>', { desc = '[C]quickfix [C]lose' })
map('n', ']q', '<cmd>cnext<CR>',          { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<CR>',          { desc = 'Prev quickfix item' })
