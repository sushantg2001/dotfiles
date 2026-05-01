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
    version = "*", 
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '?' },
        changedelete = { text = '~' },
      },
    },
  },

  -- -----------------------------------------------------------------
  -- VIM-FUGITIVE
  -- :Git for full git workflow, :Git diff, :Git commit etc.
  -- -----------------------------------------------------------------
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
  },

  -- -----------------------------------------------------------------
  -- DIFFVIEW
  -- side-by-side diffs and full file history browser
  -- -----------------------------------------------------------------
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  },
}
