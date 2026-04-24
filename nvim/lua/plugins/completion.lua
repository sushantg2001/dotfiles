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
    'hrsh7th/cmp-nvim-lsp', -- LSP
    'hrsh7th/cmp-path', -- filesystem paths
    'hrsh7th/cmp-buffer', -- words in current buffer
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

      mapping = cmp.mapping.preset.insert {
        -- navigate completion menu
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- scroll docs
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- confirm selection
        ['<C-y>'] = cmp.mapping.confirm { select = true },

        -- manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete {},

        -- dismiss
        ['<C-e>'] = cmp.mapping.abort(),

        -- Tab: confirm if menu open, else expand/jump snippet
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- Shift-Tab: jump back through snippet placeholders
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },

      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
      },
    }
  end,
}
