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
  group    = augroup('yank-highlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- =============================================================================
-- TRAILING WHITESPACE
-- strips trailing whitespace on save for all files
-- =============================================================================

autocmd('BufWritePre', {
  group   = augroup('trim-whitespace', { clear = true }),
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- =============================================================================
-- RESTORE CURSOR POSITION
-- reopens file at the last known cursor position
-- =============================================================================

autocmd('BufReadPost', {
  group    = augroup('restore-cursor', { clear = true }),
  callback = function()
    local mark  = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =============================================================================
-- RESIZE SPLITS ON WINDOW RESIZE
-- =============================================================================

autocmd('VimResized', {
  group    = augroup('resize-splits', { clear = true }),
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

-- =============================================================================
-- FILETYPE-SPECIFIC OPTIONS
-- =============================================================================

-- 2-space indent for web files
autocmd('FileType', {
  group   = augroup('web-indent', { clear = true }),
  pattern = { 'html', 'css', 'javascript', 'typescript', 'json', 'yaml', 'lua' },
  callback = function()
    vim.opt_local.tabstop   = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- wrap + spell for prose files
autocmd('FileType', {
  group   = augroup('prose-settings', { clear = true }),
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.spell     = true
    vim.opt_local.linebreak = true
  end,
})
