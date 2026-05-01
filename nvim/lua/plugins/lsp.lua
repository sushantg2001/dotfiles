-- =============================================================================
-- LSP
-- language server protocol: completions, go-to-def, rename, diagnostics
-- Mason manages LSP server binary installation
-- =============================================================================

return {
  'neovim/nvim-lspconfig',
  version      = '*',
  dependencies = {
    { 'williamboman/mason.nvim',               version = '*', opts = {} },
    { 'williamboman/mason-lspconfig.nvim',     version = '*' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },   -- no tags, lockfile only
    { 'j-hui/fidget.nvim',                     version = '*', opts = {} },
    {
      'folke/lazydev.nvim',
      version = '*',
      ft      = 'lua',
      opts    = {
        library = {
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
  config = function()
    -- -----------------------------------------------------------------
    -- CAPABILITIES — advertise nvim-cmp completion to LSP servers
    -- -----------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend(
      'force',
      capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    -- -----------------------------------------------------------------
    -- LSP SERVERS
    -- Add or remove servers here. Mason installs them automatically.
    -- Full list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    -- -----------------------------------------------------------------
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion  = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      pyright  = {},
      ts_ls    = {},
      bashls   = {},
      dockerls = {},
      yamlls   = {},
      jsonls   = {},
    }

    -- tell mason-tool-installer what to ensure is installed
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua',   -- lua formatter
      'black',    -- python formatter
      'prettier', -- js/ts/yaml/json/markdown formatter
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend(
            'force', {}, capabilities, server.capabilities or {}
          )
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}