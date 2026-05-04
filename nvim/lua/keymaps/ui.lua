-- =============================================================================
-- UI KEYMAPS
-- splits, buffers, terminal, explorer, tabs, notifications
-- =============================================================================

local map = vim.keymap.set
map('n', '<A-+>', '<C-=>', { desc = 'Increase size' })
map('n', '<A-->', '<C-->', { desc = 'Decrease size' })
map('n', '<C-+>', '<cmd>resize +2<cr>', { desc = 'Increase split height' })
map('n', '<A-->', '<cmd>resize -2<cr>', { desc = 'Decrease split height' })

map('n', '<F14>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer tab (C+])' })
map('n', '<F13>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer tab (C+[)' })
for i = 1, 9 do
  map('n', '<C-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', { desc = 'Go to buffer ' .. i })
end
map('n', '<A-h>', '<C-w>h', { desc = 'Focus left split' })
map('n', '<A-j>', '<C-w>j', { desc = 'Focus down split' })
map('n', '<A-k>', '<C-w>k', { desc = 'Focus up split' })
map('n', '<A-l>', '<C-w>l', { desc = 'Focus right split' })
map('n', '<A-]>', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '\29', '<cmd>tabprev<cr>', { desc = 'Prev tab' })

map({ 'n', 'i', 'v', 'o' }, '<A-q>', function() _G.smart_run 'ToggleTerm' end)
map('t', '<A-q>', function()
  -- Escape terminal mode, then run the smart command
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true), 'n', false)
  _G.smart_run 'ToggleTerm'
end)
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<A-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: focus left' })
map('t', '<A-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: focus right' })
map('t', '<A-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: focus down' })
map('t', '<A-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: focus up' })

local sidebar_fts = {
  'neo-tree',
  'toggleterm',
  'NvimTree',
  'trouble',
  'qf',
  'help',
  'lazy',
  'mason',
  'TelescopePrompt',
  'aerial',
  'outline',
}

local function is_sidebar(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  -- NOTE: buftype=terminal is NOT a sidebar - :terminal creates a normal
  -- window with a terminal buffer. treat it like any other buffer.
  -- only toggleterm (filetype = 'toggleterm') is a sidebar.
  for _, v in ipairs(sidebar_fts) do
    if ft == v then return true end
  end
  return false
end

local function get_editor_wins()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  return vim.tbl_filter(function(w)
    local cfg = vim.api.nvim_win_get_config(w)
    return cfg.relative == '' and not is_sidebar(w)
  end, wins)
end

local function smart_close()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype
  if is_sidebar(vim.api.nvim_get_current_win()) then
    vim.cmd 'close'
    return
  end

  local editor_wins = get_editor_wins()

  if #editor_wins > 1 then
    vim.cmd 'close'
  else
    local ok = pcall(vim.cmd, 'Bdelete')
    if not ok then vim.cmd 'bdelete' end
  end
end

map('n', '<C-x>', smart_close, { desc = 'Smart close split/buffer' })
map('n', '<A-x>', '<cmd>qa!<cr>', { desc = 'Force quit all' })

map({ 'n', 'i', 'v' }, '<A-\\>', function()
  local ok, zen = pcall(require, 'zen-mode')
  if ok then
    zen.toggle()
  else
    vim.notify('zen-mode.nvim not installed', vim.log.levels.WARN)
  end
end, { desc = 'Toggle zen mode' })
