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
map({ 'n', 'v', 'o' }, 'K', '5k', { noremap = true, desc = '5 lines up' })
map('n', '<C-j>', '<C-e>', { desc = 'Scroll down' })
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspOverride', { clear = true }),
  callback = function(event)
    pcall(vim.keymap.del, 'n', '<C-k>', { buffer = event.buf })
    vim.keymap.set('n', '<C-k>', '<C-y>', {
      buffer = event.buf,
      noremap = true,
      silent = true,
      desc = 'Force Scroll Up',
    })
  end,
})
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
        fallback() -- Triggers the <C-t> indent map above
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback() -- Triggers the <C-d> outdent map above
      end
    end, { 'i', 's' }),
    ['<C-e>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  },
}

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<Tab>'] = require('telescope.actions').move_selection_next,
        ['<S-Tab>'] = require('telescope.actions').move_selection_previous,
      },
      n = {
        ['<C-e>'] = require('telescope.actions').preview_scrolling_down,
        ['<C-b>'] = require('telescope.actions').preview_scrolling_up,
      },
    },
  },
}

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

map('n', '<C-e>', '<C-d>zz', { desc = 'Scroll down (centred)' })
map('n', '<C-b>', '<C-u>zz', { desc = 'Scroll up (centred)' })

map('i', '<C-a>', '<C-o>A', { desc = 'cursor at end of line' })
map('i', '<Char-0x1b>[105;5u', '<C-o>I', { desc = 'Force cursor to start of line' })
map('i', '<C-i>', '<C-o>I', { desc = 'Cursor at start of line' })

map('n', ']]', [[/<C-r>=escape(']', '/')<CR><CR>]], { desc = 'Next ]' })
map('n', '[[', [[?<C-r>=escape('[', '/')<CR><CR>]], { desc = 'Prev [' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Next Diagnostic' })
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Previous Diagnostic' })

map('n', ']h', function()
  if vim.wo.diff then return ']h' end
  vim.schedule(function() require('gitsigns').nav_hunk('next') end)
  return '<Ignore>'
end, { expr = true, desc = 'Next Hunk' })
map('n', '[h', function()
  if vim.wo.diff then return '[h' end
  vim.schedule(function() require('gitsigns').nav_hunk('prev') end)
  return '<Ignore>'
end, { expr = true, desc = 'Previous Hunk' })

local ok, harpoon = pcall(require, 'harpoon')
if ok then
  map('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd file' })

  map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })

  map('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
  map('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
  map('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
  map('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
end
