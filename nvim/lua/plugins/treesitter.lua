return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  main = 'nvim-treesitter',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'dockerfile',
      'go',
      'html',
      'javascript',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'rust',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },

    -- 1. INCREMENTAL SELECTION: Smartly expand selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>', -- Start selecting based on syntax
        node_incremental = '<C-space>', -- Expand selection to next scope
        node_decremental = '<M-space>', -- Shrink selection (Alt + Space)
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = { query = '@function.outer', desc = 'Around function' },
          ['if'] = { query = '@function.inner', desc = 'Inside function' },
          ['ac'] = { query = '@class.outer', desc = 'Around class' },
          ['ic'] = { query = '@class.inner', desc = 'Inside class' },
          ['aa'] = { query = '@parameter.outer', desc = 'Around argument' },
          ['ia'] = { query = '@parameter.inner', desc = 'Inside argument' },
          ['ii'] = { query = '@conditional.outer', desc = 'Around if' },
          ['ai'] = { query = '@conditional.inner', desc = 'Inside if' },
          ['al'] = { query = '@loop.outer', desc = 'Around loop' },
          ['il'] = { query = '@loop.inner', desc = 'Inside loop' },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
          [']a'] = '@parameter.inner', -- Jump to next argument
          [']i'] = '@conditional.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
          ['[a'] = '@parameter.inner', -- Jump to previous argument
          ['[i'] = '@conditional.outer',
        },
      },
      -- 2. SWAP: Physically move code elements
      swap = {
        enable = true,
        swap_next = {
          ['<leader>na'] = '@parameter.inner', -- Swap argument with next
          ['<leader>nf'] = '@function.outer', -- Swap function with next
        },
        swap_previous = {
          ['<leader>pa'] = '@parameter.inner', -- Swap argument with previous
          ['<leader>pf'] = '@function.outer', -- Swap function with previous
        },
      },
    },
  },
}
