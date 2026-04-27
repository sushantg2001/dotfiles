-- =============================================================================
-- MOTION
-- Everything that moves the cursor.
-- Sources: vim native + harpoon
-- VSCode reference: Navigation keys table
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
-- LINE MOTION
-- =============================================================================

-- H / L  start / end of line (override screen-top/bottom defaults)
map({ 'n', 'v' }, 'H', '^', { desc = 'Start of line' })
map({ 'n', 'v' }, 'L', '$', { desc = 'End of line' })

-- =============================================================================
-- VERTICAL MOTION
-- =============================================================================

-- J / K  5 lines down / up (override join-lines and hover defaults)
-- join lines moved to <leader>jj  (see tools.lua)
-- LSP hover moved to <C-Space>    (see lsp.lua)
map({ 'n', 'v' }, 'J', '5j', { desc = '5 lines down' })
map({ 'n', 'v' }, 'K', '5k', { desc = '5 lines up' })

-- keep cursor centred when scrolling half-pages
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centred)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centred)' })

-- viewport-relative cursor positioning (VSCode Ctrl+b / Ctrl+e)
map({ 'n', 'v' }, '<C-b>', 'H', { desc = 'Cursor to top of viewport' })
map({ 'n', 'v' }, '<C-e>', 'L', { desc = 'Cursor to bottom of viewport' })

-- =============================================================================
-- WORD MOTION
-- w W b B e E - all default, no changes needed
-- =============================================================================

-- =============================================================================
-- FIND CHAR MOTION
-- f F t T - all default, no changes needed
-- > / <  next / prev f/t result (VSCode > / <)
-- default ; and , are reassigned in search.lua
-- =============================================================================

map({ 'n', 'v' }, '>', ';', { desc = 'Next f/t match' })
map({ 'n', 'v' }, '<', ',', { desc = 'Prev f/t match' })

-- =============================================================================
-- PARAGRAPH / SECTION
-- { } - default paragraph jumps, no changes needed
-- [ ] - default section jumps, no changes needed
-- =============================================================================

-- =============================================================================
-- WRAPPED LINE MOTION
-- move by visual lines when no count given
-- =============================================================================

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- =============================================================================
-- HARPOON - quick file jumping
-- <leader>ha = mark file, <leader>hh = menu, <leader>1-4 = jump
-- =============================================================================

local ok, harpoon = pcall(require, 'harpoon')
if ok then
  map('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd file' })

  map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })

  map('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
  map('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
  map('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
  map('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
end
