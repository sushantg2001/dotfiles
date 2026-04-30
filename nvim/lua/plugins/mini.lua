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
}
