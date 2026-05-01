-- -----------------------------------------------------------------
-- TOGGLETERM
-- managed terminal windows with persistent state
-- keymaps in keymaps/ui.lua
-- -----------------------------------------------------------------

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        -- -----------------------------------------------------------------
        -- SIZE
        -- for horizontal: number of rows
        -- for vertical: proportion of window width
        -- can also be a function: size = function(term)
        --   if term.direction == 'horizontal' then return 15
        --   elseif term.direction == 'vertical' then return vim.o.columns * 0.4
        --   end
        -- end
        -- -----------------------------------------------------------------
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
          end
        end,

        -- -----------------------------------------------------------------
        -- OPEN / CLOSE
        -- open_mapping triggers the default terminal toggle
        -- mapped in keymaps/ui.lua to <C-\> and <A-q>
        -- -----------------------------------------------------------------
        hide_numbers = true, -- hide line numbers in terminal
        shade_terminals = true, -- slightly shade terminal bg
        shading_factor = 2, -- how much to shade (1-3)
        start_in_insert = true, -- enter insert mode when opening
        insert_mappings = true, -- open_mapping works in insert mode
        terminal_mappings = true, -- open_mapping works in terminal mode
        persist_size = true, -- remember terminal size
        persist_mode = true, -- remember terminal mode (insert/normal)
        close_on_exit = true, -- close terminal window when process exits
        auto_scroll = true, -- scroll to bottom on new output

        -- -----------------------------------------------------------------
        -- DIRECTION
        -- 'horizontal' | 'vertical' | 'float' | 'tab'
        -- default for <C-\> toggle - lazygit uses float (see keymaps/git.lua)
        -- -----------------------------------------------------------------
        direction = 'horizontal',

        -- -----------------------------------------------------------------
        -- SHELL
        -- defaults to vim.o.shell - override per OS if needed
        -- -----------------------------------------------------------------
        shell = vim.o.shell,

        -- -----------------------------------------------------------------
        -- FLOAT SETTINGS
        -- used when direction = 'float'
        -- -----------------------------------------------------------------
        float_opts = {
          border = 'curved', -- 'single'|'double'|'shadow'|'curved'
          width = math.floor(vim.o.columns * 0.85),
          height = math.floor(vim.o.lines * 0.85),
          winblend = 3, -- transparency (0 = opaque, 100 = invisible)
        },

        -- -----------------------------------------------------------------
        -- WINBAR
        -- show terminal name in winbar (nvim 0.8+)
        -- -----------------------------------------------------------------
        winbar = {
          enabled = true,
          name_formatter = function(term) return string.format('%d: %s', term.id, term.name) end,
        },
      }
    end,
  },
}
