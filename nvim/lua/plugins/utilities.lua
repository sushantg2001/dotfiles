return {
  -- Buffers: Delete without messing up your layout
  {
    'famiu/bufdelete.nvim',
    config = function() end,
  },

  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    config = function()
      require('window-picker').setup {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      }
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    version = '*',
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
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('spectre').setup() end,
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      -- You can add flash-specific config here
      modes = {
        search = {
          enabled = true, -- This allows flash to enhance your regular / search
        },
      },
    },
  },
  'folke/which-key.nvim',
  event = 'VimEnter',
  version = '*',
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
  },
}
