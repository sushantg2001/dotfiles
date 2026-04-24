-- =============================================================================
-- GIT
-- gitsigns: inline git decorations and hunk operations
-- vim-fugitive: full git workflow from inside nvim
-- diffview: side-by-side diffs and file history
-- =============================================================================

return {
  -- -----------------------------------------------------------------
  -- GITSIGNS
  -- shows added/changed/removed lines in the signcolumn
  -- -----------------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '?' },
        changedelete = { text = '~' },
      },
      on_attach = function(buf)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set

        -- navigation
        map('n', ']h', gs.next_hunk, { buffer = buf, desc = 'Next git [H]unk' })
        map('n', '[h', gs.prev_hunk, { buffer = buf, desc = 'Prev git [H]unk' })

        -- hunk actions
        map('n', '<leader>hs', gs.stage_hunk, { buffer = buf, desc = '[H]unk [S]tage' })
        map('n', '<leader>hr', gs.reset_hunk, { buffer = buf, desc = '[H]unk [R]eset' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = buf, desc = '[H]unk [U]ndo stage' })
        map('n', '<leader>hp', gs.preview_hunk, { buffer = buf, desc = '[H]unk [P]review' })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { buffer = buf, desc = '[H]unk [B]lame' })

        -- buffer actions
        map('n', '<leader>hS', gs.stage_buffer, { buffer = buf, desc = '[H]unk [S]tage buffer' })
        map('n', '<leader>hR', gs.reset_buffer, { buffer = buf, desc = '[H]unk [R]eset buffer' })

        -- text object: select hunk
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = buf, desc = 'Select git hunk' })
      end,
    },
  },

  -- -----------------------------------------------------------------
  -- VIM-FUGITIVE
  -- :Git for full git workflow, :Git diff, :Git commit etc.
  -- -----------------------------------------------------------------
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
      { '<leader>gs', '<cmd>Git<CR>', desc = '[G]it [S]tatus' },
      { '<leader>gc', '<cmd>Git commit<CR>', desc = '[G]it [C]ommit' },
      { '<leader>gp', '<cmd>Git push<CR>', desc = '[G]it [P]ush' },
      { '<leader>gl', '<cmd>Git log --oneline<CR>', desc = '[G]it [L]og' },
      { '<leader>gd', '<cmd>Gdiffsplit<CR>', desc = '[G]it [D]iff split' },
    },
  },

  -- -----------------------------------------------------------------
  -- DIFFVIEW
  -- side-by-side diffs and full file history browser
  -- -----------------------------------------------------------------
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<CR>', desc = '[G]it diff[V]iew' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = '[G]it repo [H]istory' },
      { '<leader>gx', '<cmd>DiffviewClose<CR>', desc = '[G]it close diff' },
    },
  },
}
