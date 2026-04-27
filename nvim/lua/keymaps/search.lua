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

-- =============================================================================
-- TELESCOPE - find anything
-- Ctrl+g = quick open (VSCode Ctrl+g)
-- Ctrl+f = find in file (VSCode Ctrl+f)
-- Ctrl+s = symbols in file (VSCode Ctrl+s)
-- Alt+s  = symbols in workspace (VSCode Alt+s)
-- =============================================================================

local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then return end

-- quick open (VSCode Ctrl+g)
map({ 'n', 'i', 'v' }, '<C-g>', telescope.find_files, { desc = 'Quick open files' })

-- open recent (VSCode Alt+g)
map({ 'n', 'i', 'v' }, '<A-g>', telescope.oldfiles, { desc = 'Open recent files' })

-- find in file / buffer fuzzy (VSCode Ctrl+f)
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

-- symbol navigation in file (VSCode Ctrl+s)
map({ 'n', 'i', 'v' }, '<C-s>', telescope.lsp_document_symbols, { desc = 'Symbols in file' })

-- symbol navigation in workspace (VSCode Alt+s)
map({ 'n', 'i', 'v' }, '<A-s>', telescope.lsp_dynamic_workspace_symbols, { desc = 'Symbols in workspace' })

-- show all open editors / buffers (VSCode Ctrl+o)
map({ 'n', 'i', 'v' }, '<C-o>', telescope.buffers, { desc = 'Show open buffers' })

-- open files quick access (VSCode Alt+o)
map({ 'n', 'i', 'v' }, '<A-o>', telescope.find_files, { desc = 'Open files' })

-- =============================================================================
-- REPLACE
-- Ctrl+t = replace in file (VSCode Ctrl+t)
-- Ctrl+w = replace all occurrences (VSCode Ctrl+w)
-- Ctrl+Shift+w = replace previous occurrence (VSCode Ctrl+Shift+w)
-- Using vim's native :s for these - Telescope doesn't have replace
-- =============================================================================

-- replace in file (opens substitution command)
map('n', '<C-t>', ':%s/', { desc = 'Replace in file' })
map('v', '<C-t>', ':s/', { desc = 'Replace in selection' })

-- replace word under cursor across file
map('n', '<C-w>', ':%s/<C-r><C-w>//g<Left><Left>', { desc = 'Replace all occurrences of word' })

-- =============================================================================
-- LEADER SEARCH GROUP
-- <leader>s prefix for less frequent search operations
-- =============================================================================

map('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', telescope.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', telescope.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = '[S]earch [T]odos' })
