return {
  'nvim-treesitter/nvim-treesitter',
  build        = ':TSUpdate',
  event        = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  main = 'nvim-treesitter',
  opts = {
    ensure_installed = {
      'bash', 'c', 'css', 'dockerfile', 'go', 'html',
      'javascript', 'json', 'lua', 'markdown', 'markdown_inline',
      'python', 'rust', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
    },
    auto_install = true,
    highlight = { enable = true },
    indent    = { enable = true },
    textobjects = {
      select = {
        enable    = true,
        lookahead = true,
        keymaps   = {
          ['af'] = { query = '@function.outer', desc = 'Around function' },
          ['if'] = { query = '@function.inner', desc = 'Inside function' },
          ['ac'] = { query = '@class.outer',    desc = 'Around class' },
          ['ic'] = { query = '@class.inner',    desc = 'Inside class' },
          ['aa'] = { query = '@parameter.outer', desc = 'Around argument' },
          ['ia'] = { query = '@parameter.inner', desc = 'Inside argument' },
        },
      },
      move = {
        enable          = true,
        set_jumps       = true,
        goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
      },
    },
  },
}
