-- =============================================================================
-- LAZY.NVIM BOOTSTRAP + PLUGIN LOADER
-- Works on: WSL, Windows, Linux
-- =============================================================================

-- detect OS locally - cannot rely on vim.g here as init.lua
-- sets those after this file may be required
local is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1

local lazypath = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy', 'lazy.nvim')
local lazy_init = vim.fs.joinpath(lazypath, 'lua', 'lazy', 'init.lua')

if not (vim.uv or vim.loop).fs_stat(lazy_init) then
  -- wipe broken/incomplete directory using OS-appropriate command
  -- vim.fn.delete('rf') is unreliable on Windows, use native commands
  if is_windows then
    vim.fn.system { 'cmd', '/c', 'rmdir', '/s', '/q', lazypath }
  else
    vim.fn.system { 'rm', '-rf', lazypath }
  end

  vim.notify('Bootstrapping lazy.nvim...', vim.log.levels.INFO)

  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }

  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '?',
      config = '??',
      event = '??',
      ft = '??',
      init = '?',
      keys = '??',
      plugin = '??',
      runtime = '??',
      source = '??',
      start = '??',
      task = '??',
    },
  },
  root = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
  change_detection = { notify = false },
})
