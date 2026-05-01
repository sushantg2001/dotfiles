-- =============================================================================
-- UI
-- colorscheme + statusline
-- =============================================================================

return {
  -- -----------------------------------------------------------------
  -- COLORSCHEME - tokyonight (kickstart default)
  -- priority = 1000 ensures it loads before everything else
  -- swap name + colorscheme call to change theme
  -- -----------------------------------------------------------------
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    version = '*',
    config = function()
      require('tokyonight').setup {
        style = 'night', -- night | storm | day | moon
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
