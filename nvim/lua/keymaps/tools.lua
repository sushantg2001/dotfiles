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
map({ 'n', 'i', 'v' }, '\30', '<cmd>wa<cr>', { desc = 'Save all files (via Alt+Enter)' })
map('n', '<CR>', 'o<Esc>k', { desc = 'Add blank line below' })
map('n', '<S-CR>', 'O<Esc>j', { desc = 'Add blank line above' })

map('n', '<A-x>', '<cmd>qa!<cr>', { desc = 'Force quit all' })
map('n', '<A-x>', '<cmd>qa!<cr>', { desc = 'Force quit all' })
map('n', '<C-x>', '<cmd>Bdelete<cr>', { desc = 'Close buffer' })

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

local ok, builtin = pcall(require, 'telescope.builtin')
if ok then
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-/>', builtin.marks, { desc = 'Telescope: List marks' })
  vim.keymap.set({ 'n', 'i', 'v' }, "<C-'>", builtin.registers, { desc = 'Telescope: Open registers' })
end

map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<cr>', { desc = 'Prev quickfix item' })
map('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist item' })
map('n', '[l', '<cmd>lprev<cr>', { desc = 'Prev loclist item' })

local todo_ok, todo = pcall(require, 'todo-comments')
if todo_ok then
  map('n', ']t', function() todo.jump_next() end, { desc = 'Next TODO' })
  map('n', '[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
end

map('n', '<leader>rc', '<cmd>RemoteStart<cr>', { desc = '[R]emote [C]onnect' })
map('n', '<leader>rx', '<cmd>RemoteStop<cr>', { desc = '[R]emote disconnect [X]' })
map('n', '<leader>ri', '<cmd>RemoteInfo<cr>', { desc = '[R]emote [I]nfo' })
map('n', '<leader>rl', '<cmd>RemoteLog<cr>', { desc = '[R]emote [L]og' })
map('n', '<leader>rk', '<cmd>RemoteCleanup<cr>', { desc = '[R]emote [K]ill + cleanup' })
map('n', '<leader>rt', '<cmd>RemoteTerminal<cr>', { desc = 'Remote Terminal' })
