-- =============================================================================
-- TOOLS
-- harpoon: quick file switching between marked files
-- toggleterm: managed terminal windows
-- =============================================================================

return {
  -- -----------------------------------------------------------------
  -- HARPOON 2
  -- mark your 4 active files, jump between them instantly
  -- workflow: <leader>ha to mark, <leader>1-4 to jump
  -- -----------------------------------------------------------------
  {
    'ThePrimeagen/harpoon',
    branch       = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config       = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      local map = vim.keymap.set

      map('n', '<leader>ha', function() harpoon:list():add() end,
        { desc = '[H]arpoon [A]dd file' })

      map('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon menu' })

      map('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
      map('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
      map('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
      map('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
    end,
  },

  -- -----------------------------------------------------------------
  -- TOGGLETERM
  -- managed terminal windows, including lazygit float
  -- <C-\> to toggle terminal
  -- <leader>gg to open lazygit
  -- -----------------------------------------------------------------
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config  = function()
      require('toggleterm').setup {
        open_mapping    = [[<C-\>]],
        direction       = 'horizontal',
        size            = 15,
        shade_terminals = true,
        shading_factor  = 2,
      }

      -- lazygit float (requires lazygit installed)
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit  = Terminal:new {
        cmd       = 'lazygit',
        direction = 'float',
        hidden    = true,
        float_opts = {
          border = 'curved',
        },
      }

      vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end,
        { desc = '[G]it la[G]it' })
    end,
  },
}
