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
map('n', '<CR>', 'o<Esc>k', { desc = 'Add blank line below' })
map('n', '<S-CR>', 'O<Esc>j', { desc = 'Add blank line above' })
map({ 'n', 'i', 'v' }, '<C-CR>', '<cmd>w<cr><esc>', { desc = 'Save file (via ctrl+enter)' })
map({ 'n', 'i', 'v' }, '\30', '<cmd>wa<cr>', { desc = 'Save all files (via Alt+Enter)' })

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<C-c>'] = cmp.mapping.abort(),
    ['<Esc>'] = cmp.mapping.abort(),
  },
}

map({ 'n', 'v', 'o' }, '"', '"0', { desc = 'Fixed register a' })
map({ 'n', 'v', 'o' }, "'", '"', { desc = 'Register prefix' })

map({ 'n', 'v', 'o' }, '/', 'm', { desc = 'Mark position' })
map({ 'n', 'v', 'o' }, '?', '`', { desc = 'Go to mark' })

map({ 'n', 'v', 'o' }, '`', '<cmd>Telescope keymaps<cr>', { desc = 'Keymaps' })

map('n', '<BS>', '<C-o>', { desc = 'Jump back' })
map('n', '\28', '<C-i>', { desc = 'Jump forward' })

local ok, builtin = pcall(require, 'telescope.builtin')
if ok then
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-/>', builtin.marks, { desc = 'Telescope: List marks' })
  vim.keymap.set({ 'n', 'i', 'v' }, "<C-'>", builtin.registers, { desc = 'Telescope: Open registers' })
end

local todo_ok, todo = pcall(require, 'todo-comments')
if todo_ok then
  map('n', ']t', function() todo.jump_next() end, { desc = 'Next TODO' })
  map('n', '[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
end
