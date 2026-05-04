-- =============================================================================
-- SEARCH
-- Everything that finds something.
-- Sources: vim native + telescope
-- VSCode reference: Navigation (Ctrl+f/g/l/h/s) + Function keys (;/:)
-- =============================================================================

local map = vim.keymap.set

map({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
map({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

map('n', ';', 'n', { desc = 'Next search match' })
map('n', ':', 'N', { desc = 'Next search match' })
map({ 'n', 'v' }, '<C-h>', '?', { desc = 'forward search' })
map({ 'n', 'v' }, '<C-l>', '/', { desc = 'backward search' })

map({ 'n', 'o', 'v' }, '>', ';', { desc = 'Next f/t match' })
map({ 'n', 'o', 'v' }, '<', ',', { desc = 'Prev f/t match' })

local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then return end
map({ 'n', 'i', 'v' }, '<C-f>', function()
  local opt = require('telescope.themes').get_dropdown { previewer = false }
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.cmd 'normal! "zy'
    opt.default_text = vim.fn.getreg 'z'
  end
  telescope.current_buffer_fuzzy_find(opt)
end, { desc = 'Find in file (with selection support)' })

map('n', '<A-f>', telescope.live_grep, { desc = 'Find in all files' })
map('v', '<A-f>', function()
  vim.cmd 'normal! "zy'
  local selection = vim.fn.getreg 'z'
  telescope.grep_string { search = selection }
end, { desc = 'Find selection in all files' })
map('n', '<C-t>', ':%s/', { desc = 'Replace in file' })
map('v', '<C-t>', ':s/', { desc = 'Replace in selection' })
map('n', '<A-t>', "<cmd>lua require('spectre').open()<CR>", { desc = 'Replace in project' })

map({ 'n', 'i', 'v' }, '<C-s>', telescope.lsp_document_symbols, { desc = 'Symbols in file' })
map({ 'n', 'i', 'v' }, '<A-s>', telescope.lsp_dynamic_workspace_symbols, { desc = 'Symbols in workspace' })
map({ 'n', 'i', 'v' }, '<C-o>', telescope.buffers, { desc = 'Show open buffers' })
map({ 'n', 'i', 'v' }, '<A-o>', telescope.find_files, { desc = 'Open files' })
map('n', '<C-w>', ':%s/<C-r><C-w>//g<Left><Left>', { desc = 'Replace all occurrences of word' })
