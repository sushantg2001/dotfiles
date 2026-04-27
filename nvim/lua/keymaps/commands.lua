-- =============================================================================
-- COMMANDS - intent menu system
-- Replicates your VSCode Commands extension menu system using which-key.
-- Single letter = intent group. Pause after letter to see menu.
--
-- r = frequent editor commands   (VSCode r)
-- R = frequent app commands      (VSCode R)
-- q = run / build commands       (VSCode Ctrl+q)
-- Q = play macro                 (covered in tools.lua)
-- z = new intent commands        (VSCode z)
-- Z = file intent commands       (VSCode Z)
-- m = editor AI / machine        (VSCode m)
-- M = app AI / machine           (VSCode M)
--
-- NOTE: these override vim defaults in normal mode:
--   r  = replace char       moved to <leader>rc or use native R for replace mode
--   z  = fold commands      moved to <leader>z prefix
--   m  = set mark           use native m{a-z} instead
-- =============================================================================

local map = vim.keymap.set
local wk = require 'which-key'

-- =============================================================================
-- REGISTER GROUPS WITH WHICH-KEY
-- =============================================================================

wk.add {
  -- top-level intent groups
  { 'r', group = 'Editor commands' },
  { 'R', group = 'App commands' },
  { 'q', group = 'Run / Build' },
  { 'z', group = 'New intent' },
  { 'Z', group = 'File intent' },
  { 'm', group = 'Editor AI' },
  { 'M', group = 'App AI' },

  -- leader subgroups
  { '<leader>b', group = '[B]uffer' },
  { '<leader>g', group = '[G]it' },
  { '<leader>h', group = 'Git [H]unk' },
  { '<leader>j', group = '[J]oin' },
  { '<leader>l', group = '[L]SP' },
  { '<leader>lw', group = '[L]SP [W]orkspace' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]ab' },
  { '<leader>x', group = 'Diagnostics' },
}

-- =============================================================================
-- r - EDITOR COMMANDS
-- frequent operations on the current file / editor
-- =============================================================================

map('n', 'rf', function() require('conform').format { async = true } end, { desc = 'Format file' })

map('n', 'rr', '<cmd>LspRestart<cr>', { desc = 'Restart LSP' })

map('n', 'rd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })

map('n', 'rD', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Workspace diagnostics' })

map('n', 'rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

map('n', 'ra', vim.lsp.buf.code_action, { desc = 'Code action' })

map('n', 'rh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end, { desc = 'Toggle inlay hints' })

map('n', 'rw', '<cmd>set wrap!<cr>', { desc = 'Toggle word wrap' })

map('n', 'rs', '<cmd>set spell!<cr>', { desc = 'Toggle spell check' })

map('n', 'rc', 'r', { desc = 'Replace single char (native r)' })

-- =============================================================================
-- R - APP COMMANDS
-- frequent operations on the neovim app itself
-- =============================================================================

map('n', 'Rl', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
map('n', 'Rm', '<cmd>Mason<cr>', { desc = 'Open Mason' })
map('n', 'Rh', '<cmd>checkhealth<cr>', { desc = 'Check health' })
map('n', 'Rq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', 'RQ', '<cmd>qa!<cr>', { desc = 'Force quit all' })
map('n', 'Rs', '<cmd>wa<cr>', { desc = 'Save all buffers' })

map('n', 'Rc', function() require('telescope.builtin').colorscheme { enable_preview = true } end, { desc = 'Change colorscheme' })

map('n', 'Rk', '<cmd>Telescope keymaps<cr>', { desc = 'Browse keymaps' })

-- =============================================================================
-- q - RUN / BUILD
-- VSCode Ctrl+q = build/run commands
-- populate with your project-specific runners
-- =============================================================================

map('n', 'qt', '<cmd>ToggleTerm<cr>', { desc = 'Open terminal' })

map(
  'n',
  'qf',
  function() require('toggleterm.terminal').Terminal:new({ cmd = 'make', direction = 'float', close_on_exit = false }):toggle() end,
  { desc = 'Run make' }
)

map(
  'n',
  'qi',
  function() require('toggleterm.terminal').Terminal:new({ cmd = 'npm install', direction = 'float', close_on_exit = false }):toggle() end,
  { desc = 'npm install' }
)

map(
  'n',
  'qr',
  function() require('toggleterm.terminal').Terminal:new({ cmd = 'npm run dev', direction = 'float', close_on_exit = false }):toggle() end,
  { desc = 'npm run dev' }
)

map(
  'n',
  'qb',
  function() require('toggleterm.terminal').Terminal:new({ cmd = 'npm run build', direction = 'float', close_on_exit = false }):toggle() end,
  { desc = 'npm run build' }
)

-- =============================================================================
-- z - NEW INTENT
-- commands with "create something new" intent
-- VSCode z/Z
-- NOTE: vim fold commands (za, zo, zc etc.) still work - only bare z is a group
-- =============================================================================

map('n', 'zf', '<cmd>enew<cr>', { desc = 'New file (unnamed buffer)' })
map('n', 'zb', '<cmd>enew<cr>', { desc = 'New buffer' })
map('n', 'zt', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', 'zs', '<cmd>split enew<cr>', { desc = 'New horizontal split' })
map('n', 'zv', '<cmd>vsplit enew<cr>', { desc = 'New vertical split' })
map('n', 'zn', function()
  local name = vim.fn.input 'New file name: '
  if name ~= '' then vim.cmd('edit ' .. name) end
end, { desc = 'New named file' })

-- =============================================================================
-- Z - FILE INTENT
-- commands with "do something to the current file" intent
-- =============================================================================

map('n', 'Zs', '<cmd>w<cr>', { desc = 'Save file' })
map('n', 'ZS', '<cmd>wa<cr>', { desc = 'Save all files' })

map('n', 'Zr', function()
  local old = vim.fn.expand '%'
  local new = vim.fn.input('Rename to: ', old)
  if new ~= '' and new ~= old then
    vim.cmd('saveas ' .. new)
    vim.fn.delete(old)
    vim.cmd 'redraw'
  end
end, { desc = 'Rename file' })

map('n', 'Zd', function()
  local file = vim.fn.expand '%'
  local confirm = vim.fn.input('Delete ' .. file .. '? [y/N]: ')
  if confirm:lower() == 'y' then
    vim.fn.delete(file)
    vim.cmd 'bd!'
  end
end, { desc = 'Delete file' })

map('n', 'Zc', function()
  local file = vim.fn.expand '%:p'
  vim.fn.setreg('+', file)
  vim.notify('Copied: ' .. file, vim.log.levels.INFO)
end, { desc = 'Copy file path to clipboard' })

map('n', 'Zf', function()
  vim.fn.setreg('+', vim.fn.expand '%:t')
  vim.notify('Copied: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
end, { desc = 'Copy filename to clipboard' })

map('n', 'Zx', '<cmd>bd<cr>', { desc = 'Close file / buffer' })

-- =============================================================================
-- m - EDITOR AI / MACHINE
-- AI operations scoped to the current editor/buffer
-- Populate with your AI plugin keymaps when added
-- =============================================================================

wk.add { { 'm', group = 'Editor AI (pending setup)' } }

-- placeholder - wire in your AI plugin here
-- e.g. for avante.nvim:
-- map('n', 'ma', '<cmd>AvanteAsk<cr>',  { desc = 'AI ask' })
-- map('n', 'mc', '<cmd>AvanteChat<cr>', { desc = 'AI chat' })
-- map('v', 'me', '<cmd>AvanteEdit<cr>', { desc = 'AI edit selection' })

-- =============================================================================
-- M - APP AI / MACHINE
-- AI operations at the app / workspace level
-- =============================================================================

wk.add { { 'M', group = 'App AI (pending setup)' } }

-- placeholder - wire in your AI plugin here
-- e.g.:
-- map('n', 'Ms', '<cmd>AvanteToggle<cr>', { desc = 'AI sidebar toggle' })
-- map('n', 'Mh', '<cmd>AvanteHistory<cr>', { desc = 'AI history' })
