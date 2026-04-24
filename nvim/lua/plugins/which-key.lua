-- =============================================================================
-- WHICH-KEY
-- shows popup of available keybindings when pausing mid-sequence
-- =============================================================================

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts  = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]quickfix' },
      { '<leader>d', group = '[D]elete (no yank)' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch / [S]plit' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>x', group = 'Diagnostics / [X]' },
    },
  },
}
