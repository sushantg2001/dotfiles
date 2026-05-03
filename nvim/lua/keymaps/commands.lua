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
-- guard: neo-tree needs at least 40 columns to open without E36
local function neotree(cmd)
  if vim.o.columns < 40 then
    vim.notify('Window too small for explorer', vim.log.levels.WARN)
    return
  end
  vim.cmd('Neotree ' .. cmd)
end
-- r - commands mode
map({ 'v', 'n' }, 'r', ':', { desc = 'commands mode' })

-- R - workspace commands
map('n', 'R', '<Nop>', { desc = 'Disable default Replace mode' })
wk.add {
  { 'R', group = 'App commands' },
}

map('n', 'Rr', 'r', { desc = 'Replace letter' })
map('n', 'RR', 'R', { desc = 'Open replace mode' })
map('n', 'Rl', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
map('n', 'Rm', '<cmd>Mason<cr>', { desc = 'Open Mason' })
map('n', 'Rh', '<cmd>checkhealth<cr>', { desc = 'Check health' })
map('n', 'Rq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', 'RQ', '<cmd>qa!<cr>', { desc = 'Force quit all' })
map('n', 'Rs', '<cmd>wa<cr>', { desc = 'save all' })

-- z - file/splits/explorer commands
wk.add {
  { 'z', group = 'Explorer/buffer/tabs/splits commands' },
}
map('n', 'zz', function() neotree 'toggle' end, { desc = 'Toggle Explorer' })
map('n', 'zf', function() neotree 'reveal' end, { desc = 'Explorer reveal [F]ile' })
map('n', 'zb', function() neotree 'buffers' end, { desc = '[E]xplorer [B]uffers' })
map('n', 'zl', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer tab' })
map('n', 'zh', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer tab' })
map('n', 'zs', '<cmd>vsplit<CR>', { desc = 'Split Vertically' })
map('n', 'zS', '<cmd>split<CR>', { desc = 'Split Horizontally' })
map('n', 'zx', '<C-w>c', { desc = '[C]lose current split' })
map('n', 'zm', '<C-w>o', { desc = 'Close [O]ther splits (Maximize)' })
map('n', 'ze', '<C-w>=', { desc = '[E]qualize split sizes' })

-- Z - Git/Github/tabs/projects commands
wk.add {
  { 'Z', group = 'Explorer/file commands' },
}
map('n', 'Zg', '<cmd>Neogit<CR>', { desc = 'Neo[G]it Status' })
map('n', 'Zc', '<cmd>Git commit<CR>', { desc = '[C]ommit (Fugitive)' })
map('n', 'ZP', '<cmd>Git push<CR>', { desc = '[P]ush' })
map('n', 'Zl', '<cmd>Git pull<CR>', { desc = 'Pu[l]l' })
map('n', 'Zd', '<cmd>DiffviewOpen<CR>', { desc = '[D]iff Project' })
map('n', 'Zh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File [H]istory' })
map('n', 'Zx', '<cmd>GitConflictListQf<CR>', { desc = 'List Conflict [X]' })
map('n', 'Zp', '<cmd>Gitsigns preview_hunk<CR>', { desc = '[p]review Hunk' })
map('n', 'Zs', '<cmd>Gitsigns stage_hunk<CR>', { desc = '[S]tage Hunk' })
map('n', 'Zr', '<cmd>Gitsigns reset_hunk<CR>', { desc = '[R]eset Hunk' })
map('n', 'Zb', '<cmd>Gitsigns blame_line<CR>', { desc = 'Git [B]lame' })
map('n', 'Zi', '<cmd>Octo issue list<CR>', { desc = 'GitHub [I]ssues' })
map('n', 'Zr', '<cmd>Octo pr list<CR>', { desc = 'GitHub [R]equests (PRs)' })
map('n', 'Zo', '<cmd>Octo repo browse<CR>', { desc = '[O]pen Repo in Browser' })

-- n - new buffers/split/code
wk.add {
  { 'n', group = 'Explorer/file commands' },
}
map('n', 'nf', ':e %:p:h/', { desc = 'New file (local dir)' })
map('n', 'nt', 'o-- TODO: <esc>A', { desc = 'New TODO comment' })
map('n', 'nd', function() vim.diagnostic.jump { count = 1 } end, { desc = 'New (Next) Diagnostic' })
map('n', 'nh', '<cmd>Gitsigns next_hunk<cr>', { desc = 'New (Next) Git Hunk' })

-- n - new tabs/workspace/etc..
wk.add {
  { 'N', group = 'Explorer/file commands' },
}
map('n', 'Ns', '<cmd>RemoteStart<cr>', { desc = 'New Remote Session' })
map('n', 'Nf', '<cmd>Telescope find_files<cr>', { desc = 'New Workspace File' })
map('n', 'Nt', '<cmd>vnew | terminal<cr>', { desc = 'New Terminal Split' })
map('n', 'Nw', '<cmd>vnew<cr>', { desc = 'New Empty Window' })
map('n', 'Nr', '<cmd>Telescope oldfiles<cr>', { desc = 'New Recent Files List' })
