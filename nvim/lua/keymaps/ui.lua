-- =============================================================================
-- UI
-- Everything that manages the workspace layout.
-- =============================================================================

local map = vim.keymap.set

map('n', '<A-h>', '<C-w><C-h>', { desc = 'Focus left split' })
map('n', '<A-j>', '<C-w><C-j>', { desc = 'Focus lower split' })
map('n', '<A-k>', '<C-w><C-k>', { desc = 'Focus upper split' })
map('n', '<A-l>', '<C-w><C-l>', { desc = 'Focus right split' })

map('n', '<leader>sv', '<C-w>v', { desc = '[S]plit [V]ertical' })
map('n', '<leader>sh', '<C-w>s', { desc = '[S]plit [H]orizontal' })
map('n', '<leader>se', '<C-w>=', { desc = '[S]plit [E]qualise' })
map('n', '<leader>so', '<C-w>o', { desc = '[S]plit [O]nly (close others)' })
map('n', '<leader>sx', '<cmd>close<cr>', { desc = '[S]plit [X] close' })

map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase split height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease split height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease split width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase split width' })

map('n', '<C-]>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<C-[>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })

map('n', '<C-x>', '<cmd>bd<cr>', { desc = 'Close buffer / editor' })

map({ 'n', 'i', 'v' }, '<A-q>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
map({ 'n', 'i', 'v' }, '<C-\\>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-x>', '<cmd>ToggleTerm<cr>', { desc = 'Close terminal' })

map('t', '<C-]>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: focus left split' })
map('t', '<C-[>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: focus right split' })

map({ 'n', 'i', 'v' }, '<A-\\>', function()
  local ok, zen = pcall(require, 'zen-mode')
  if ok then
    zen.toggle()
  else
    vim.notify('zen-mode.nvim not installed', vim.log.levels.WARN)
  end
end, { desc = 'Toggle zen mode' })

map({ 'n', 'i', 'v' }, '<C-.>', '<Esc><C-w>p', { desc = 'Focus editor' })

map('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = '[T]ab [N]ew' })
map('n', '<leader>tx', '<cmd>tabclose<cr>', { desc = '[T]ab [X] close' })
map('n', '<leader>to', '<cmd>tabonly<cr>', { desc = '[T]ab [O]nly' })
map('n', ']T', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '[T', '<cmd>tabprev<cr>', { desc = 'Prev tab' })
