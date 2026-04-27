-- =============================================================================
-- LSP
-- Everything that uses language intelligence.
-- Set inside LspAttach so keymaps are buffer-local and only active
-- when an LSP server is actually connected.
-- VSCode reference: gd conflict resolved - LSP go-to-def moved to <leader>ld
-- NOTE: K (hover) moved to <C-Space> since K is now 5 lines up (motion.lua)
--       gd moved to <leader>ld since gd is now clipboard delete (editing.lua)
-- =============================================================================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('keymaps-lsp', { clear = true }),
  callback = function(event)
    local map = vim.keymap.set
    local buf = event.buf

    -- -----------------------------------------------------------------
    -- NAVIGATION
    -- -----------------------------------------------------------------

    -- go to definition (moved from gd - gd is now clipboard delete)
    map('n', '<leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = '[L]SP go to [D]efinition' })

    -- go to declaration
    map('n', '<leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = '[L]SP go to [D]eclaration' })

    -- go to implementation
    map('n', '<leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = '[L]SP go to [I]mplementation' })

    -- go to type definition
    map('n', '<leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = '[L]SP [T]ype definition' })

    -- references in telescope picker
    map('n', '<leader>lr', require('telescope.builtin').lsp_references, { buffer = buf, desc = '[L]SP [R]eferences' })

    -- -----------------------------------------------------------------
    -- DOCUMENTATION
    -- hover docs moved from K (K is now 5 lines up)
    -- -----------------------------------------------------------------

    map('n', '<C-Space>', vim.lsp.buf.hover, { buffer = buf, desc = 'LSP hover docs' })

    map('n', '<leader>lk', vim.lsp.buf.signature_help, { buffer = buf, desc = '[L]SP signature [K] help' })

    -- -----------------------------------------------------------------
    -- ACTIONS
    -- -----------------------------------------------------------------

    -- rename symbol
    map('n', '<leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = '[L]SP [R]ename symbol' })

    -- code actions
    map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { buffer = buf, desc = '[L]SP code [A]ction' })

    -- format buffer via LSP
    map('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, { buffer = buf, desc = '[L]SP [F]ormat' })

    -- -----------------------------------------------------------------
    -- DIAGNOSTICS
    -- -----------------------------------------------------------------

    map('n', '[d', vim.diagnostic.goto_prev, { buffer = buf, desc = 'Prev diagnostic' })

    map('n', ']d', vim.diagnostic.goto_next, { buffer = buf, desc = 'Next diagnostic' })

    map('n', '<leader>le', vim.diagnostic.open_float, { buffer = buf, desc = '[L]SP diagnostic [E]rror float' })

    map('n', '<leader>lq', vim.diagnostic.setloclist, { buffer = buf, desc = '[L]SP diagnostic [Q]uickfix' })

    -- -----------------------------------------------------------------
    -- WORKSPACE
    -- -----------------------------------------------------------------

    map('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, { buffer = buf, desc = '[L]SP [W]orkspace [A]dd folder' })

    map('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, { buffer = buf, desc = '[L]SP [W]orkspace [R]emove folder' })

    map(
      'n',
      '<leader>lwl',
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { buffer = buf, desc = '[L]SP [W]orkspace [L]ist folders' }
    )

    -- -----------------------------------------------------------------
    -- INLAY HINTS TOGGLE (nvim 0.10+)
    -- -----------------------------------------------------------------

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.supports_method 'textDocument/inlayHint' then
      map(
        'n',
        '<leader>lh',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf }) end,
        { buffer = buf, desc = '[L]SP toggle inlay [H]ints' }
      )
    end

    -- -----------------------------------------------------------------
    -- REFERENCE HIGHLIGHTING ON CURSOR HOLD
    -- -----------------------------------------------------------------

    if client and client.supports_method 'textDocument/documentHighlight' then
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
