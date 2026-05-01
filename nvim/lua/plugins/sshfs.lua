return {
  'nosduco/remote-sshfs.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    local remote_sshfs = require 'remote-sshfs'

    remote_sshfs.setup {
      connections = {
        ssh_configs = { -- Thread through your existing SSH config
          vim.fn.expand '$HOME/.ssh/config',
        },
        sshfs_args = {
          '-o',
          'reconnect',
          '-o',
          'ConnectTimeout=5',
          '-o',
          'cache=yes',
          '-o',
          'allow_other',
        },
      },
      mounts = {
        -- Use a clean path without special characters
        base_dir = vim.fn.expand '$HOME/.sshfs/',
        unmount_on_exit = true,
      },
      handlers = {
        on_connect = {
          change_dir = true, -- Automatically CD into the mount
        },
      },
      -- This uses the standard UI for picking, avoiding the Telescope crash
      ui = {
        select_prompts = true,
      },
    }

    -- Load telescope extension
    require('telescope').load_extension 'remote-sshfs'
  end,
}
