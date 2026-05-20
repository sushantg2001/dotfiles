-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- =============================================================================
-- YANK HIGHLIGHT
-- briefly highlights yanked region
-- =============================================================================

autocmd('TextYankPost', {
  group = augroup('yank-highlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- =============================================================================
-- TRAILING WHITESPACE
-- strips trailing whitespace on save for all files
-- =============================================================================

autocmd('BufWritePre', {
  group = augroup('trim-whitespace', { clear = true }),
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- =============================================================================
-- RESTORE CURSOR POSITION
-- reopens file at the last known cursor position
-- =============================================================================

autocmd('BufReadPost', {
  group = augroup('restore-cursor', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- =============================================================================
-- RESIZE SPLITS ON WINDOW RESIZE
-- =============================================================================

autocmd('VimResized', {
  group = augroup('resize-splits', { clear = true }),
  callback = function() vim.cmd 'tabdo wincmd =' end,
})

-- =============================================================================
-- FILETYPE-SPECIFIC OPTIONS
-- =============================================================================

-- 2-space indent for web files
autocmd('FileType', {
  group = augroup('web-indent', { clear = true }),
  pattern = { 'html', 'css', 'javascript', 'typescript', 'json', 'yaml', 'lua' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- wrap + spell for prose files
autocmd('FileType', {
  group = augroup('prose-settings', { clear = true }),
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  callback = function()
    local win_config = vim.api.nvim_win_get_config(0)

    -- If the window is relative (a float), map Esc to close it
    if win_config.relative ~= '' then vim.keymap.set('n', '<C-c>', ':q<cr>', { buffer = true, silent = true, nowait = true }) end
  end,
})
-- Close all visible floating windows without moving the cursor
local function close_unfocused_floats()
  -- Get all windows open in the current tab
  local windows = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(windows) do
    -- Get configuration for each window
    local config = vim.api.nvim_win_get_config(win)

    -- If 'relative' has a value, it means it's a floating window
    if config.relative and config.relative ~= '' then
      -- Safeguard: Avoid closing essential utility UIs like which-key if it's open
      local bufnr = vim.api.nvim_win_get_buf(win)
      local filetype = vim.bo[bufnr].filetype

      if filetype ~= 'which-key' then
        -- Safely close the window
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end
end

vim.keymap.set('n', '<C-c>', close_unfocused_floats, {
  silent = true,
  desc = 'Close unfocused hover windows',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function(args)
    local bufnr = args.data and args.data.bufnr or args.buf
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      if vim.bo[bufnr].filetype == 'markdown' then pcall(vim.treesitter.stop, bufnr) end
    end
  end,
})
