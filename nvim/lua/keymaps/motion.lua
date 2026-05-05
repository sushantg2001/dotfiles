-- =============================================================================
-- MOTION
-- Everything that moves the cursor.
-- =============================================================================

local map = vim.keymap.set

map({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Start of line' })
map({ 'n', 'v', 'o' }, 'L', '$', { desc = 'End of line' })
map('i', '<C-l>', '<right>')
map('i', '<C-h>', '<left>')

map({ 'n', 'v', 'o' }, 'J', '5j', { desc = '5 lines down' })
map({ 'n', 'v', 'o' }, 'K', '5k', { desc = '5 lines up' })
map({ 'i' }, 'jk', '<Esc>', { desc = 'Escape in insert' })
map({ 'i' }, 'kj', '<Esc>', { desc = 'Escape in insert' })
map('n', '<C-j>', '<C-e>', { desc = 'Scroll down' })
map('n', '<C-k>', '<C-y>', { desc = 'Scroll up' })
map('i', '<C-j>', '<down>')
map('i', '<C-k>', '<up>')
map('v', '<C-j>', ":m '>+1<CR>gv=gv")
map('v', '<C-k>', ":m '<-2<CR>gv=gv")

local cmp = require 'cmp'
cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
}

local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<tab>'] = 'move_selection_next',
        ['<s-tab>'] = 'move_selection_previous',
        ['<c-l>'] = 'move_selection_next',
        ['<c-h>'] = 'move_selection_previous',
        ['<c-k>'] = 'preview_scrolling_up',
        ['<c-j>'] = 'preview_scrolling_down',
      },
      n = {
        ['k'] = 'move_selection_previous',
        ['j'] = 'move_selection_next',
        ['<c-j>'] = 'preview_scrolling_down',
        ['<c-k>'] = 'preview_scrolling_up',
        ['<esc>'] = 'close',
      },
    },
  },
}

require('neo-tree').setup {
  window = {
    mappings = {
      ['r'] = 'none',
      ['R'] = 'none',
      ['q'] = 'none',
      ['Q'] = 'none',
      ['z'] = 'none',
      ['Z'] = 'none',
      ['n'] = 'none',
      ['N'] = 'none',
      ['m'] = 'none',
      ['M'] = 'none',
      ['<space>'] = 'none',
      ['/'] = 'none',
      ['?'] = 'none',
      ['H'] = 'none',
      ['L'] = 'none',
      ['J'] = 'none',
      ['K'] = 'none',
      ['\\'] = 'toggle_hidden',
      ['<C-CR>'] = {
        'toggle_preview',
        config = { use_float = true, base = 'right', width = 45, title = 'preview' },
      },
      ['\30'] = function(state)
        local node = state.tree:get_node()
        if not node then return end
        if node.type == 'directory' then
          require('neo-tree.sources.filesystem.commands').toggle_node(state)
          return
        end
        local preview = require 'neo-tree.sources.common.preview'
        local current_win = vim.api.nvim_get_current_win()
        local tree_win = state.winid
        if preview.is_active() then
          if current_win == tree_win then
            require('neo-tree.sources.common.commands').focus_preview(state)
          else
            vim.api.nvim_set_current_win(tree_win)
          end
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-CR>', true, false, true), 'm', false)
          vim.defer_fn(function() require('neo-tree.sources.common.commands').focus_preview(state) end, 75) -- Increased slightly to 75ms for WSL stability
        end
      end,
      ['<Esc>'] = 'clear_filter',
      ['<C-c>'] = 'clear_filter',
      ['<CR>'] = 'open',
      ['<Tab>'] = 'set_root',
      ['<S-Tab>'] = 'navigate_up',
      ['b'] = 'prev_source',
      ['e'] = 'next_source',
      ['i'] = 'open_leftabove_vs',
      ['a'] = 'open_rightbelow_vs',
      ['t'] = 'filter_on_submit',
      ['f'] = 'fuzzy_finder',
      ['o'] = { 'add', config = { show_path = 'none' } },
      ['O'] = 'add_directory',
      ['x'] = 'delete',
      ['X'] = 'close_window',
      ['c'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['Y'] = 'copy',
      ['d'] = 'cut_to_clipboard',
      ['D'] = 'move',
      ['p'] = 'paste_from_clipboard',
      ['.'] = 'refresh',
    },
  },
}

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

map('n', '<C-e>', '<C-d>zz', { desc = 'Scroll down (centred)' })
map('n', '<C-b>', '<C-u>zz', { desc = 'Scroll up (centred)' })

map('i', '<C-a>', '<C-o>A', { desc = 'cursor at end of line' })
map('i', '<C-i>', '<C-o>I', { desc = 'Cursor at start of line' })

map('n', ']]', [[/<C-r>=escape(']', '/')<CR><CR>]], { desc = 'Next ]' })
map('n', '[[', [[?<C-r>=escape('[', '/')<CR><CR>]], { desc = 'Prev [' })
map('n', ']d', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Next Diagnostic' })
map('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Previous Diagnostic' })
map('n', ']h', function()
  if vim.wo.diff then return ']h' end
  vim.schedule(function() require('gitsigns').nav_hunk 'next' end)
  return '<Ignore>'
end, { expr = true, desc = 'Next Hunk' })
map('n', '[h', function()
  if vim.wo.diff then return '[h' end
  vim.schedule(function() require('gitsigns').nav_hunk 'prev' end)
  return '<Ignore>'
end, { expr = true, desc = 'Previous Hunk' })
map('n', ']]', [[/<C-r>=escape(']', '/')<CR><CR>]], { desc = 'Next ]' })
map('n', '[[', [[?<C-r>=escape('[', '/')<CR><CR>]], { desc = 'Prev [' })

map({ 'n', 'v' }, '\\', 'z', { desc = 'remap \\ to z' })
map({ 'n', 'v' }, '\\\\', 'zz', { desc = 'remap \\ to z' })

local ok, harpoon = pcall(require, 'harpoon')
if ok then
  map('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd file' })
  map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })
  map('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
  map('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
  map('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
  map('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
end
