-- =============================================================================
-- SEARCH
-- Everything that finds something.
-- Sources: vim native + telescope
-- VSCode reference: Navigation (Ctrl+f/g/l/h/s) + Function keys (;/:)
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

map('n', ';', 'n', { desc = 'Next search match' })
map('n', ':', 'N', { desc = 'Next search match' })
map({ 'n', 'v' }, '<C-h>', '?', { desc = 'forward search' })
map({ 'n', 'v' }, '<C-l>', '/', { desc = 'backward search' })

map({ 'n', 'v' }, '>', ';', { desc = 'Next f/t match' })
map({ 'n', 'v' }, '<', ',', { desc = 'Prev f/t match' })

local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then return end

map({ 'n', 'i', 'v' }, '<C-g>', telescope.find_files, { desc = 'Quick open files' })
map({ 'n', 'i', 'v' }, '<A-g>', telescope.oldfiles, { desc = 'Open recent files' })
map(
  { 'n', 'i', 'v' },
  '<C-f>',
  function()
    telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      previewer = false,
    })
  end,
  { desc = 'Find in file' }
)

map({ 'n', 'i', 'v' }, '<C-s>', telescope.lsp_document_symbols, { desc = 'Symbols in file' })
map({ 'n', 'i', 'v' }, '<A-s>', telescope.lsp_dynamic_workspace_symbols, { desc = 'Symbols in workspace' })
map({ 'n', 'i', 'v' }, '<C-o>', telescope.buffers, { desc = 'Show open buffers' })
map({ 'n', 'i', 'v' }, '<A-o>', telescope.find_files, { desc = 'Open files' })
map('n', '<C-t>', ':%s/', { desc = 'Replace in file' })
map('v', '<C-t>', ':s/', { desc = 'Replace in selection' })
map('n', '<C-w>', ':%s/<C-r><C-w>//g<Left><Left>', { desc = 'Replace all occurrences of word' })

map('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', telescope.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', telescope.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = '[S]earch [T]odos' })
