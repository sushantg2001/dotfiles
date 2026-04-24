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
    config   = function()
      require('tokyonight').setup {
        style       = 'night',   -- night | storm | day | moon
        transparent = false,
        styles      = {
          comments = { italic = true },
          keywords = { italic = true },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- -----------------------------------------------------------------
  -- MINI.STATUSLINE
  -- lightweight statusline from the mini.nvim collection
  -- -----------------------------------------------------------------
  {
    'echasnovski/mini.statusline',
    version  = '*',
    config   = function()
      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
      }
      -- override the cursor location section to show LINE:COL
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
