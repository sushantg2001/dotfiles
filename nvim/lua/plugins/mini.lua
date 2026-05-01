return {
  'echasnovski/mini.ai',
  version = '*',
  event = 'VeryLazy',
  opts = function()
    local ai = require 'mini.ai'
    return {
      n_lines = 500,
      custom_textobjects = {
        -- Use Treesitter for these (Keep these as they are)
        f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
        c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
        a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
        o = ai.gen_spec.treesitter {
          a = { '@conditional.outer', '@loop.outer' },
          i = { '@conditional.inner', '@loop.inner' },
        },

        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        d = { '%f[%d]%d+' },
      },
      mappings = {
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
      },
    }
  end,

  {
    'echasnovski/mini.statusline',
    version = '*',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
      }
      -- override the cursor location section to show LINE:COL
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- -----------------------------------------------------------------
  -- MINI.SURROUND
  -- ys{motion}{char} = add surround
  -- cs{old}{new}     = change surround
  -- ds{char}         = delete surround
  -- -----------------------------------------------------------------
  {
    'echasnovski/mini.surround',
    version = '*',
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    },
  },
}
