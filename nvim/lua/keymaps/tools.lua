-- =============================================================================
-- TOOLS
-- Utility features: macros, marks, registers, quickfix, todos
-- =============================================================================

local map = vim.keymap.set

map('n', 'Q', '@@', { desc = 'Play last macro' })

local ok, telescope = pcall(require, 'telescope.builtin')
if ok then map({ 'n', 'i', 'v' }, '<C-/>', telescope.marks, { desc = 'List marks' }) end

if ok then map({ 'n', 'i', 'v' }, "<C-'>", telescope.registers, { desc = 'Open registers' }) end

map('n', '<leader>jj', 'J', { desc = '[J]oin lines' })
map('n', '<leader>jJ', 'gJ', { desc = '[J]oin lines (no space)' })

map('n', '<leader>co', '<cmd>copen<cr>', { desc = '[C]quickfix [O]pen' })
map('n', '<leader>cc', '<cmd>cclose<cr>', { desc = '[C]quickfix [C]lose' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<cr>', { desc = 'Prev quickfix item' })

-- location list (per-window quickfix)
map('n', '<leader>lo', '<cmd>lopen<cr>', { desc = '[L]oclist [O]pen' })
map('n', '<leader>lc', '<cmd>lclose<cr>', { desc = '[L]oclist [C]lose' })
map('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist item' })
map('n', '[l', '<cmd>lprev<cr>', { desc = 'Prev loclist item' })

local todo_ok, todo = pcall(require, 'todo-comments')
if todo_ok then
  map('n', ']t', function() todo.jump_next() end, { desc = 'Next TODO' })
  map('n', '[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
end

map('n', '<CR>', 'o<Esc>k', { desc = 'Add blank line below' })
map('n', '<S-CR>', 'O<Esc>j', { desc = 'Add blank line above' })

map('n', '<leader>v', 'ggVG', { desc = 'Select all' })
