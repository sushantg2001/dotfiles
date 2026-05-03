return {
  'amitds1997/remote-nvim.nvim',
  version = '*',
  config = function()
    local local_version = string.format('v%d.%d.%d', vim.version().major, vim.version().minor, vim.version().patch)
    local cache_file = vim.fn.stdpath 'cache' .. '/remote-nvim-paths.json'

    _G.RemoteState = { active_port = nil, terminal_buf = nil }

    -- THE UNIVERSAL SMART RUNNER
    -- This handles the logic: If focused on remote window, send via API. Otherwise, run locally.
    _G.smart_run = function(cmd)
      if vim.api.nvim_get_current_buf() == _G.RemoteState.terminal_buf and _G.RemoteState.active_port then
        -- Mapping-proof API call
        local rpc = string.format('nvim --server localhost:%d --remote-expr "nvim_command(\'%s\')"', _G.RemoteState.active_port, cmd)
        vim.fn.jobstart(rpc)
      else
        vim.cmd(cmd)
      end
    end

    -- Path persistence logic
    local function load_paths(host)
      if vim.fn.filereadable(cache_file) == 0 then return {} end
      local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(cache_file)))
      return (ok and data and data[host]) or {}
    end

    local function save_path(host, path)
      local all = load_paths(host)
      if vim.fn.filereadable(cache_file) == 1 then
        local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(cache_file)))
        if ok and data then all = data end
      end
      if not all[host] then all[host] = {} end
      table.insert(all[host], 1, path)
      local seen, unique = {}, {}
      for _, p in ipairs(all[host]) do
        if not seen[p] then
          seen[p] = true
          table.insert(unique, p)
        end
      end
      all[host] = vim.list_slice(unique, 1, 8)
      vim.fn.writefile({ vim.fn.json_encode(all) }, cache_file)
    end

    require('remote-nvim').setup {
      neovim_version = local_version,
      progress_view = { type = 'popup' },
      offline_mode = { enabled = false },
      client_callback = function(port, workspace_config)
        local host = workspace_config.host
        local saved = load_paths(host)

        local function start_session(path)
          local clean_path = path:gsub('^%s*', ''):gsub('%s*$', '')
          save_path(host, clean_path)

          _G.RemoteState.active_port = port
          -- API call to CD prevents your ':' and 'C-U' remaps from interfering
          local safe_cd = string.format('nvim --server localhost:%d --remote-expr "nvim_set_current_dir(\'%s\')"', port, clean_path)
          vim.defer_fn(function() vim.fn.jobstart(safe_cd) end, 800)

          require('remote-nvim.ui').float_term(string.format('nvim --server localhost:%d --remote-ui', port), function()
            _G.RemoteState.active_port = nil
            _G.RemoteState.terminal_buf = nil
          end)
          _G.RemoteState.terminal_buf = vim.api.nvim_get_current_buf()
        end

        if #saved > 0 then
          local items = { 'New path...' }
          for _, p in ipairs(saved) do
            table.insert(items, p)
          end
          vim.ui.select(items, { prompt = 'Select Workspace on ' .. host }, function(choice)
            if not choice then return end
            start_session(choice == 'New path...' and vim.fn.input('Path: ', '~/') or choice)
          end)
        else
          vim.ui.input({ prompt = 'Folder on ' .. host .. ': ', default = '~/' }, start_session)
        end
      end,
    }
  end,
}
