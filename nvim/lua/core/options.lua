-- =============================================================================
-- EDITOR OPTIONS
-- =============================================================================

local opt = vim.opt

-- disable swap file and set undo history
vim.opt.swapfile = false -- No more .swp files
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand '~/.local/state/nvim/undo//'

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs / indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- display
opt.wrap = false
opt.cursorline = true
opt.signcolumn = 'yes' -- always show gutter (prevents layout jump)
opt.showmode = false -- redundant with a statusline
opt.scrolloff = 10 -- keep 10 lines above/below cursor
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split' -- live preview of :s/ substitutions

-- search
opt.ignorecase = true
opt.smartcase = true -- case-sensitive if query has uppercase
opt.hlsearch = true

-- splits
opt.splitright = true
opt.splitbelow = true

-- behaviour
opt.mouse = 'a'
opt.clipboard = ''
opt.breakindent = true -- wrapped lines preserve indentation
opt.undofile = true -- persist undo history across sessions
opt.updatetime = 250 -- faster CursorHold / LSP hover
opt.timeoutlen = 300 -- how long to wait for key sequence

-- =============================================================================
-- OS-SPECIFIC OVERRIDES
-- =============================================================================

if vim.g.is_wsl then
  -- clipboard bridge: WSL  Windows clip.exe
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

if vim.g.is_windows then
  -- use powershell instead of cmd.exe
  opt.shell = 'powershell'
  opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  opt.shellquote = ''
  opt.shellxquote = ''

  -- windows needs explicit path separator for backslash handling
  opt.shellslash = true
end
