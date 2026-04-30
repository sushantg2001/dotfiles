-- =============================================================================
-- COMPLETION
-- nvim-cmp: completion engine
-- LuaSnip: snippet engine
-- sources: LSP, snippets, buffer words, file paths
-- =============================================================================

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- snippet engine
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- skip jsregexp build on Windows (not essential)
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- friendly-snippets: a large snippet collection
        {
          'rafamadriz/friendly-snippets',
          config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        },
      },
    },

    -- sources
    'saadparwaiz1/cmp_luasnip', -- snippets
    'hrsh7th/cmp-nvim-lsp',     -- LSP
    'hrsh7th/cmp-path',         -- filesystem paths
    'hrsh7th/cmp-buffer',       -- words in current buffer
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },

      completion = {
        completeopt = 'menu,menuone,noinsert',
      },

      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip',  priority = 750 },
        { name = 'buffer',   priority = 500 },
        { name = 'path',     priority = 250 },
      },
    }
  end,
}
