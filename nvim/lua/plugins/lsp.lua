-- =============================================================================
-- LSP
-- language server protocol: completions, go-to-def, rename, diagnostics
-- Mason manages LSP server binary installation
-- =============================================================================

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- mason: installs LSP server binaries
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP status in bottom right
    { 'j-hui/fidget.nvim', opts = {} },

    -- lua LSP aware of nvim API (for editing your own config)
    { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } } },
  },
  config = function()
    -- -----------------------------------------------------------------
    -- ON ATTACH - runs when LSP connects to a buffer
    -- all LSP keymaps live here
    -- -----------------------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = vim.keymap.set
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- navigation
        map('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = '[G]oto [D]efinition' })
        map('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = '[G]oto [D]eclaration' })
        map('n', 'gI', vim.lsp.buf.implementation, { buffer = buf, desc = '[G]oto [I]mplementation' })
        map('n', 'gr', require('telescope.builtin').lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
        map('n', 'gt', vim.lsp.buf.type_definition, { buffer = buf, desc = '[G]oto [T]ype definition' })

        -- docs
        map('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'Hover documentation' })
        map('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf, desc = 'Signature help' })

        -- actions
        map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = buf, desc = '[R]e[n]ame symbol' })
        map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = buf, desc = '[C]ode [A]ction' })

        -- workspace
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = buf, desc = '[W]orkspace [A]dd folder' })
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = buf, desc = '[W]orkspace [R]emove folder' })
        map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { buffer = buf, desc = '[W]orkspace [L]ist folders' })

        -- diagnostics
        map('n', '[d', vim.diagnostic.goto_prev, { buffer = buf, desc = 'Prev [D]iagnostic' })
        map('n', ']d', vim.diagnostic.goto_next, { buffer = buf, desc = 'Next [D]iagnostic' })
        map('n', '<leader>e', vim.diagnostic.open_float, { buffer = buf, desc = 'Show diagnostic [E]rror' })

        -- toggle inlay hints (nvim 0.10+)
        if client and client:supports_method 'textDocument/inlayHint' then
          map(
            'n',
            '<leader>th',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf }) end,
            { buffer = buf, desc = '[T]oggle inlay [H]ints' }
          )
        end

        -- highlight references on cursor hold
        if client and client:supports_method 'textDocument/documentHighlight' then
          local hi_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = buf,
            group = hi_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = buf,
            group = hi_group,
            callback = vim.lsp.buf.clear_references,
          })
          -- clean up highlight group when LSP detaches
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(e)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
            end,
          })
        end
      end,
    })

    -- -----------------------------------------------------------------
    -- CAPABILITIES - advertise nvim-cmp completion to LSP servers
    -- -----------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- -----------------------------------------------------------------
    -- LSP SERVERS
    -- Add or remove servers here. Mason installs them automatically.
    -- Full list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    -- -----------------------------------------------------------------
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      pyright = {},
      ts_ls = {},
      bashls = {},
      dockerls = {},
      yamlls = {},
      jsonls = {},
    }

    -- tell mason-tool-installer what to ensure is installed
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua', -- lua formatter
      'black', -- python formatter
      'prettier', -- js/ts/yaml/json formatter
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
