-- =============================================================================
-- EDITOR
-- text objects, surround, formatting, todo highlighting
-- =============================================================================

return {
  -- -----------------------------------------------------------------
  -- MINI.AI - extended text objects
  -- vaf = select around function, via = inside argument, etc.
  -- -----------------------------------------------------------------
  {
    'echasnovski/mini.ai',
    version = '*',
    opts = { n_lines = 500 },
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

  -- -----------------------------------------------------------------
  -- TODO-COMMENTS
  -- highlights TODO: FIXME: NOTE: HACK: etc. in comments
  -- <leader>st to search all todos via Telescope
  -- -----------------------------------------------------------------
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odos' },
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Prev TODO' },
    },
  },

  -- -----------------------------------------------------------------
  -- CONFORM - formatting
  -- <leader>f to format current file
  -- format-on-save enabled by default
  -- -----------------------------------------------------------------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_fallback = true } end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
      },
    },
  },
}
