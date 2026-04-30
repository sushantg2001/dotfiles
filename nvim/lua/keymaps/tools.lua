-- =============================================================================
-- TOOLS
-- Utility features: macros, marks, registers, quickfix, todos
-- =============================================================================

local map = vim.keymap.set
map('i', '<Tab>', '<C-t>', { desc = 'Indent line' })
map('i', '<S-Tab>', '<C-d>', { desc = 'Outdent line' })
map('n', '<Tab>', '>>', { desc = 'Indent line' })
map('n', '<S-Tab>', '<<', { desc = 'De-indent line' })
map('v', '<Tab>', '>gv', { desc = 'Indent selection' })
map('v', '<S-Tab>', '<gv', { desc = 'De-indent selection' })

map('n', '<CR>', 'o<Esc>', { desc = 'Add line below' })
map('n', '<S-CR>', 'O<Esc>', { desc = 'Add line above' })
map({ 'n', 'i', 'v' }, '<C-CR>', '<cmd>w<cr><esc>', { desc = 'Save file' })
map('n', '<CR>', 'o<Esc>k', { desc = 'Add blank line below' })
map('n', '<S-CR>', 'O<Esc>j', { desc = 'Add blank line above' })

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<C-c>'] = cmp.mapping.abort(),
  },
}

map({ 'n', 'v', 'o' }, '"', '"0', { desc = 'Fixed register a' })
map({ 'n', 'v', 'o' }, "'", '"', { desc = 'Register prefix' })

local ok, builtin = pcall(require, 'telescope.builtin')
if ok then
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-/>', builtin.marks, { desc = 'Telescope: List marks' })
  vim.keymap.set({ 'n', 'i', 'v' }, "<C-'>", builtin.registers, { desc = 'Telescope: Open registers' })
end

map('n', '<leader>jj', 'J', { desc = '[J]oin lines' })
map('n', '<leader>jJ', 'gJ', { desc = '[J]oin lines (no space)' })
map('n', '<leader>co', '<cmd>copen<cr>', { desc = '[C]quickfix [O]pen' })
map('n', '<leader>cc', '<cmd>cclose<cr>', { desc = '[C]quickfix [C]lose' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<cr>', { desc = 'Prev quickfix item' })
map('n', '<leader>lo', '<cmd>lopen<cr>', { desc = '[L]oclist [O]pen' })
map('n', '<leader>lc', '<cmd>lclose<cr>', { desc = '[L]oclist [C]lose' })
map('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist item' })
map('n', '[l', '<cmd>lprev<cr>', { desc = 'Prev loclist item' })

local todo_ok, todo = pcall(require, 'todo-comments')
if todo_ok then
  map('n', ']t', function() todo.jump_next() end, { desc = 'Next TODO' })
  map('n', '[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
end

map('n', '<leader>v', 'ggVG', { desc = 'Select all' })
