-- =============================================================================
-- WHICH-KEY
-- shows popup of available keybindings when pausing mid-sequence
-- =============================================================================

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  version = '*',
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
  },
}
