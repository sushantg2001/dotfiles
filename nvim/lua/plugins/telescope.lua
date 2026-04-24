-- =============================================================================
-- TELESCOPE
-- fuzzy finder for files, grep, LSP symbols, buffers, help tags
-- =============================================================================

return {
  'nvim-telescope/telescope.nvim',
  event        = 'VimEnter',
  branch       = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond  = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = { prompt_position = 'top' },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- -----------------------------------------------------------------
    -- KEYMAPS
    -- -----------------------------------------------------------------
    local map     = vim.keymap.set
    local builtin = require 'telescope.builtin'

    map('n', '<leader>sf', builtin.find_files,                { desc = '[S]earch [F]iles' })
    map('n', '<leader>sg', builtin.live_grep,                 { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sh', builtin.help_tags,                 { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps,                   { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sw', builtin.grep_string,               { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sd', builtin.diagnostics,               { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume,                    { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', builtin.oldfiles,                  { desc = '[S]earch Recent files' })
    map('n', '<leader>ss', builtin.lsp_document_symbols,      { desc = '[S]earch [S]ymbols' })
    map('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch Workspace [S]ymbols' })
    map('n', '<leader><space>', builtin.buffers,              { desc = 'Find open buffers' })

    -- grep word under cursor
    map('n', '<leader>s/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[S]earch [/] in current buffer' })
  end,
}
