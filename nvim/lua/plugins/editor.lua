-- =============================================================================
-- EDITOR
-- text objects, surround, formatting, todo highlighting
-- =============================================================================

return {
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

  -- -----------------------------------------------------------------
  -- CONFORM - formatting
  -- format-on-save enabled by default
  -- -----------------------------------------------------------------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
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
