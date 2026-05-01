-- =============================================================================
-- LSP
-- Everything that uses language intelligence.
-- Set inside LspAttach so keymaps are buffer-local and only active
-- when an LSP server is actually connected.
-- =============================================================================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('keymaps-lsp', { clear = true }),
  callback = function(event)
    local map = vim.keymap.set
    local buf = event.buf

    map('n', '<leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = '[L]SP go to [D]efinition' })
    map('n', '<leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = '[L]SP go to [D]eclaration' })
    map('n', '<leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = '[L]SP go to [I]mplementation' })
    map('n', '<leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = '[L]SP [T]ype definition' })
    map('n', '<leader>lr', require('telescope.builtin').lsp_references, { buffer = buf, desc = '[L]SP [R]eferences' })
    map('n', '<C-Space>', vim.lsp.buf.hover, { buffer = buf, desc = 'LSP hover docs' })
    map('n', '<leader>lk', vim.lsp.buf.signature_help, { buffer = buf, desc = '[L]SP signature [K] help' })
    map('n', '<leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = '[L]SP [R]ename symbol' })
    map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { buffer = buf, desc = '[L]SP code [A]ction' })
    map('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, { buffer = buf, desc = '[L]SP [F]ormat' })
    map('n', '<leader>le', vim.diagnostic.open_float, { buffer = buf, desc = '[L]SP diagnostic [E]rror float' })
    map('n', '<leader>lq', vim.diagnostic.setloclist, { buffer = buf, desc = '[L]SP diagnostic [Q]uickfix' })
    map('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, { buffer = buf, desc = '[L]SP [W]orkspace [A]dd folder' })
    map('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, { buffer = buf, desc = '[L]SP [W]orkspace [R]emove folder' })
    map(
      'n',
      '<leader>lwl',
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { buffer = buf, desc = '[L]SP [W]orkspace [L]ist folders' }
    )
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method 'textDocument/inlayHint' then
      map(
        'n',
        '<leader>lh',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf }) end,
        { buffer = buf, desc = '[L]SP toggle inlay [H]ints' }
      )
    end
    if client and client:supports_method 'textDocument/documentHighlight' then
      local hi = vim.api.nvim_create_augroup('lsp-reference-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf,
        group = hi,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = buf,
        group = hi,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-reference-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-reference-highlight', buffer = e.buf }
        end,
      })
    end
  end,
})
