-- =============================================================================
-- COMMANDS - intent menu system
-- g = goto/lsp
-- r = frequent editor commands
-- R = frequent app commands
-- q = run / build commands
-- Q = play macro
-- z = new intent commands
-- Z = file intent commands
-- m = editor AI / machine
-- M = app AI / machine

local map = vim.keymap.set
local wk = require 'which-key'
-- guard: neo-tree needs at least 40 columns to open without E36
local function neotree(cmd)
  if vim.o.columns < 40 then
    vim.notify('Window too small for explorer', vim.log.levels.WARN)
    return
  end
  vim.cmd('Neotree ' .. cmd)
end

-- q - record macro
-- Q - Play macro
map('n', 'Q', '@', { desc = 'Play macro' })

-- r - commands mode
map({ 'v', 'n' }, 'r', ':', { desc = 'commands mode' })

-- R - workspace commands
local opts = { noremap = true, silent = true }
map('n', 'Rl', '<cmd>Lazy<cr>', vim.tbl_extend('force', opts, { desc = 'Open Lazy' }))
map('n', 'Rm', '<cmd>Mason<cr>', vim.tbl_extend('force', opts, { desc = 'Open Mason' }))
map('n', 'Rh', '<cmd>checkhealth<cr>', vim.tbl_extend('force', opts, { desc = 'Check health' }))
map('n', 'Rx', '<cmd>Bdelete<cr>', vim.tbl_extend('force', opts, { desc = 'Close buffer' }))
map('n', 'Rq', '<cmd>qa<cr>', vim.tbl_extend('force', opts, { desc = 'Quit all' }))
map('n', 'Rr', 'r', { noremap = false, silent = true, desc = 'Replace char' })
local wk = require 'which-key'

wk.setup {
  triggers = {
    { '<auto>', mode = 'nxso' }, -- Keep default auto-triggers active
    { 'R', mode = 'n' }, -- MANUALLY FORCE 'R' TO WORK AS A MENU TRIGGER IN NORMAL MODE
  },
}

wk.add {
  { 'R', group = 'App commands' },
}

map({ 'n', 'v', 'i', 'x', 'o', 'c', 't' }, '<A-r>', '<cmd>Telescope commands<cr>', { desc = 'Commands' })

-- z - file/splits/tabs/explorer commands
map('n', 'z', '<Nop>', { desc = 'Disable default z' })
wk.add {
  { 'z', group = 'Explorer/buffer/tabs/splits commands' },
}
map('n', 'zz', function() neotree 'toggle' end, { desc = 'Toggle Neotree' })
map('n', 'zZ', function() neotree 'reveal' end, { desc = 'Reveal file in neotree' })
map('n', 'zf', '<cmd>BufferLinePick', { desc = 'Split Vertically' })
map('n', 'zv', '<cmd>vsplit<CR>', { desc = 'Split Vertically' })
map('n', 'zs', '<cmd>split<CR>', { desc = 'Split Horizontally' })
map('n', 'zn', '<cmd>tabnew<CR>', { desc = 'new tab' })
map('n', 'zx', '<cmd>tabclose<CR>', { desc = 'new tab' })

-- Z - Git/Github/tabs/projects commands
map('n', 'Z', '<Nop>', { desc = 'Disable default Z' })
wk.add {
  { 'Z', group = 'Explorer/file commands' },
}
map('n', 'Zg', '<cmd>Neogit<CR>', { desc = 'Neo[G]it Status' })
map('n', 'Zs', '<cmd>Git status<CR>', { desc = 'Git Status' })
map('n', 'Zc', '<cmd>Git commit<CR>', { desc = '[C]ommit (Fugitive)' })
map('n', 'ZP', '<cmd>Git push<CR>', { desc = '[P]ush' })
map('n', 'Zl', '<cmd>Git pull<CR>', { desc = 'Pu[l]l' })
map('n', 'Zd', '<cmd>DiffviewOpen<CR>', { desc = '[D]iff Project' })
map('n', 'Zh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File [H]istory' })
map('n', 'Zx', '<cmd>GitConflictListQf<CR>', { desc = 'List Conflict [X]' })

map('n', 'n', '<Nop>', { desc = 'Disable default n' })
wk.add {
  { 'n', group = 'New in editor' },
}

map('n', 'N', '<Nop>', { desc = 'Disable default N' })
wk.add {
  { 'N', group = 'New in app' },
}
map('n', 'Nn', '<cmd>enew<cr>', { desc = 'New empty buffer' })
map('n', 'Nf', function()
  local name = vim.fn.input 'File name: '
  if name ~= '' then vim.cmd('edit ' .. name) end
end, { desc = 'New named file' })
map('n', 'Nd', function()
  local dir = vim.fn.input 'Directory: '
  if dir ~= '' then vim.fn.mkdir(dir, 'p') end
end, { desc = 'New directory' })
map('n', 'Nt', '<cmd>terminal<cr>', { desc = 'New terminal (current)' })
map('n', 'Ntv', '<cmd>vsplit | terminal<cr>', { desc = 'New terminal (vsplit)' })
map('n', 'Nts', '<cmd>split | terminal<cr>', { desc = 'New terminal (split)' })

wk.add {
  { 'g', group = 'Goto/LSP' },
}

map('n', 'ga', vim.lsp.buf.code_action, { desc = 'Code action' })
map('n', 'gr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
map('n', 'gh', vim.lsp.buf.hover, { desc = 'Hover docs' })
map('n', 'gH', vim.lsp.buf.signature_help, { desc = 'Signature help' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Declaration' })
map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { desc = 'Definitions' })
map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Implementations' })
map('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Type definitions' })
map('n', 'gR', '<cmd>Telescope lsp_references<cr>', { desc = 'References' })
map('n', 'gI', '<cmd>Telescope lsp_incoming_calls<cr>', { desc = 'Incoming calls' })
map('n', 'gO', '<cmd>Telescope lsp_outgoing_calls<cr>', { desc = 'Outgoing calls' })
map('n', 'gS', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document symbols' })
map('n', 'ge', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
map('n', 'gE', '<cmd>Telescope diagnostics bufnr=0<cr>', { desc = 'Buffer diagnostics' })
map('n', 'g]', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Next diagnostic' })
map('n', 'g[', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Prev diagnostic' })
map('n', 'g}', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end, { desc = 'Next error' })
map('n', 'g{', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end, { desc = 'Prev error' })
