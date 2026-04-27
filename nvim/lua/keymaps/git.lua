-- =============================================================================
-- GIT
-- Everything that interacts with git.
-- Sources: gitsigns + vim-fugitive + diffview + toggleterm (lazygit)
-- =============================================================================

local map = vim.keymap.set

local ok, gs = pcall(require, 'gitsigns')
if ok then
  -- navigate hunks
  map('n', ']h', gs.next_hunk, { desc = 'Next git hunk' })
  map('n', '[h', gs.prev_hunk, { desc = 'Prev git hunk' })

  -- stage / reset / undo
  map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
  map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
  map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo stage' })
  map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk [S]tage selection' })
  map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk [R]eset selection' })

  -- buffer-level stage / reset
  map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage buffer' })
  map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset buffer' })

  -- preview / blame
  map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
  map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = '[H]unk [B]lame line' })
  map('n', '<leader>hB', gs.toggle_current_line_blame, { desc = '[H]unk toggle [B]lame' })

  -- diff current file
  map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff file' })

  -- text object: select hunk in visual / operator mode
  map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>', { desc = 'Select git hunk' })
end

-- =============================================================================
-- FUGITIVE - full git workflow
-- =============================================================================

-- status panel
map('n', '<leader>gs', '<cmd>Git<cr>', { desc = '[G]it [S]tatus' })
map('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = '[G]it [C]ommit' })
map('n', '<leader>gp', '<cmd>Git push<cr>', { desc = '[G]it [P]ush' })
map('n', '<leader>gP', '<cmd>Git pull<cr>', { desc = '[G]it [P]ull' })
map('n', '<leader>gl', '<cmd>Git log --oneline<cr>', { desc = '[G]it [L]og' })
map('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = '[G]it [D]iff split' })
map('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = '[G]it [B]lame' })

-- =============================================================================
-- DIFFVIEW - side-by-side diffs + file history
-- =============================================================================

map('n', '<leader>gv', '<cmd>DiffviewOpen<cr>', { desc = '[G]it diff[V]iew' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = '[G]it file [H]istory' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it repo [H]istory' })
map('n', '<leader>gx', '<cmd>DiffviewClose<cr>', { desc = '[G]it close diff' })

-- =============================================================================
-- LAZYGIT - full TUI git client in a float
-- =============================================================================

local term_ok, Terminal = pcall(function() return require('toggleterm.terminal').Terminal end)

if term_ok then
  local lazygit = Terminal:new {
    cmd = 'lazygit',
    direction = 'float',
    hidden = true,
    float_opts = { border = 'curved' },
  }
  map('n', '<leader>gg', function() lazygit:toggle() end, { desc = '[G]it la[G]it' })
end
