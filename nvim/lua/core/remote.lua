-- =============================================================================
-- NATIVE REMOTE
-- SSH into remote machines, install neovim, sync config, open session.
-- Sessions open in a tmux window (Linux) or Windows Terminal tab (WSL).
-- No neovim terminal buffer is used.
--
-- Commands:
--   :RemoteNative         connect (host > path > sync > bootstrap > open)
--   :RemoteNativeAdd      add host to ~/.ssh/config
--   :RemoteNativeSync     re-sync config without opening session
--   :RemoteNativeCleanup  wipe remote nvim install
--   :RemoteNativeStatus   check nvim/tmux/node versions on all hosts
--   :RemoteNativeLog      open log file
--   :RemoteNativeLogClear clear the log file
-- =============================================================================

local M = {}

-- =============================================================================
-- CONFIGURATION
-- =============================================================================
M.config = {
  ssh_config_path    = vim.fn.expand '~/.ssh/config',
  -- Use ~ not $HOME: ~ inside double quotes is not expanded by the local shell,
  -- so the remote shell receives and expands it to the correct remote home.
  remote_config_path = '~/.config/nvim',
  remote_bin_path    = '~/.local/bin',
  node_version       = 'v20.18.0',
  rsync_exclude      = { '.git', 'undo' },
  sync_plugins       = true,
  max_history        = 8,
  -- 'auto' = WSL -> wt, inside tmux -> tmux, else error
  -- 'tmux' = always use local tmux new-window
  -- 'wt'   = always use Windows Terminal (WSL only)
  terminal_mode      = 'auto',
  -- WSL distro name passed to wsl.exe -d (e.g. 'Ubuntu', 'Ubuntu-22.04').
  -- nil or '' = use the default WSL distro (recommended: avoids profile name guessing).
  wt_distro          = nil,
  -- Reuse one SSH connection for mkdir + rsync + bootstrap (faster)
  ssh_multiplex      = true,
  -- Write verbose DEBUG entries (every command, byte counts) to log file
  verbose            = false,
}

-- Log file: all output goes here; errors also shown as notifications
local log_file = vim.fn.stdpath 'data' .. '/native_remote.log'

-- =============================================================================
-- LOGGING
-- =============================================================================

local LEVEL_LABEL = {
  [vim.log.levels.DEBUG] = 'DEBUG',
  [vim.log.levels.INFO]  = 'INFO ',
  [vim.log.levels.WARN]  = 'WARN ',
  [vim.log.levels.ERROR] = 'ERROR',
}

--- Append one or more lines to the log file with a timestamp prefix.
--- Strips carriage returns and splits on embedded newlines.
local function write_log(level, msg)
  local f = io.open(log_file, 'a')
  if not f then return end
  local ts    = os.date '%Y-%m-%d %H:%M:%S'
  local label = LEVEL_LABEL[level] or 'INFO '
  msg = msg:gsub('\r', '')
  for line in (msg .. '\n'):gmatch '([^\n]*)\n' do
    if line ~= '' then
      f:write(string.format('%s  %s  %s\n', ts, label, line))
    end
  end
  f:close()
end

--- Write a separator block at the start of each connection attempt.
local function log_session_start(host, path)
  local f = io.open(log_file, 'a')
  if not f then return end
  local line = string.rep('-', 72)
  f:write(string.format('\n%s\n%s  Session: %s -> %s\n%s\n',
    line, os.date '%Y-%m-%d %H:%M:%S', host.name, path, line))
  f:close()
end

--- Errors go to vim.notify; everything else is log-file only.
local function notify(msg, level)
  level = level or vim.log.levels.INFO
  write_log(level, msg)
  if level >= vim.log.levels.ERROR then
    vim.notify('[NativeRemote] ' .. msg, level)
  end
end

--- Verbose debug entries (commands, byte counts) – log file only.
local function log(msg)
  if M.config.verbose then
    write_log(vim.log.levels.DEBUG, msg)
  end
end

local function log_cmd(cmd)
  log('RUN: ' .. cmd)
end

-- =============================================================================
-- HELPERS
-- =============================================================================

local function ssh_target(host)
  if host.user then
    return host.user .. '@' .. host.ip
  end
  return host.alias
end

--- Wrap a string in single quotes, escaping any embedded single quotes.
--- Use this when embedding user-supplied paths inside a remote shell command.
local function shell_quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function build_excludes()
  local parts = {}
  for _, ex in ipairs(M.config.rsync_exclude) do
    parts[#parts + 1] = "--exclude=" .. shell_quote(ex)
  end
  return table.concat(parts, ' ')
end

--- SSH ControlMaster options for multiplexed connections.
--- The control socket is per-host so parallel status checks don't collide.
local function mux_socket(host)
  return string.format('/tmp/nr-%s.sock', host.alias:gsub('[^%w_-]', '_'))
end

local function ssh_mux_opts(host)
  if not M.config.ssh_multiplex then return '' end
  return string.format(
    '-o ControlMaster=auto -o ControlPath=%s -o ControlPersist=60s',
    mux_socket(host)
  )
end

--- Close the mux socket for a host (called by cleanup).
local function close_mux(host)
  if not M.config.ssh_multiplex then return end
  os.execute(string.format('ssh -O exit -o ControlPath=%s %s 2>/dev/null',
    mux_socket(host), ssh_target(host)))
end

--- Detect which local terminal to use for opening the session.
--- Only tmux (Linux) and Windows Terminal (WSL) are supported.
--- Returns 'tmux', 'wt', or nil (unsupported).
local function detect_terminal_mode()
  if M.config.terminal_mode ~= 'auto' then
    return M.config.terminal_mode
  end
  -- WSL: Windows Terminal available via cmd.exe
  if vim.fn.executable 'cmd.exe' == 1 then
    return 'wt'
  end
  -- Local tmux: inside a session or at least installed
  if vim.fn.executable 'tmux' == 1 then
    return 'tmux'
  end
  return nil
end

-- =============================================================================
-- SSH CONFIG PARSER
-- reads ~/.ssh/config as source of truth for hosts
-- =============================================================================

local function parse_ssh_config()
  local path = vim.fn.expand(M.config.ssh_config_path)
  if vim.fn.filereadable(path) == 0 then
    notify('~/.ssh/config not found at ' .. path, vim.log.levels.ERROR)
    return {}
  end

  local hosts   = {}
  local current = nil

  for line in io.lines(path) do
    line = line:match '^%s*(.-)%s*$'
    if line == '' or line:match '^#' then goto continue end

    local host_val = line:match '^[Hh]ost%s+(.+)$'
    if host_val then
      if current and (current.ip or current.alias) then
        table.insert(hosts, current)
      end
      if host_val:match '[*?]' then
        current = nil
      else
        current = { alias = host_val, name = host_val, ip = host_val, user = nil }
      end
      goto continue
    end

    if current then
      local hostname = line:match '^[Hh]ost[Nn]ame%s+(.+)$'
      if hostname then current.ip = hostname; goto continue end
      local user = line:match '^[Uu]ser%s+(.+)$'
      if user then current.user = user; goto continue end
    end
    ::continue::
  end

  if current and (current.ip or current.alias) then
    table.insert(hosts, current)
  end

  return hosts
end

local function get_hosts()
  local hosts = parse_ssh_config()
  if #hosts == 0 then
    notify('No hosts found in ' .. M.config.ssh_config_path, vim.log.levels.WARN)
  end
  return hosts
end

-- =============================================================================
-- PERSISTENCE - recent paths per host
-- =============================================================================

local history_file = vim.fn.stdpath 'data' .. '/native_remote_history.json'

local function get_history()
  if vim.fn.filereadable(history_file) == 0 then return {} end
  local f = io.open(history_file, 'r')
  if not f then return {} end
  local data = f:read '*a'
  f:close()
  local ok, decoded = pcall(vim.fn.json_decode, data)
  return ok and decoded or {}
end

local function get_host_paths(host_ip)
  return get_history()[host_ip] or {}
end

local function save_host_path(host_ip, path)
  local history = get_history()
  if not history[host_ip] then history[host_ip] = {} end
  table.insert(history[host_ip], 1, path)
  local seen, unique = {}, {}
  for _, p in ipairs(history[host_ip]) do
    if not seen[p] then seen[p] = true; table.insert(unique, p) end
  end
  history[host_ip] = vim.list_slice(unique, 1, M.config.max_history)
  local f = io.open(history_file, 'w')
  if f then f:write(vim.fn.json_encode(history)); f:close() end
end

-- =============================================================================
-- STEP 1 - SYNC CONFIG via rsync
-- Only transfers changed files (incremental, compressed).
-- Reuses the mux connection so no second auth prompt.
-- =============================================================================

local function sync_config(host, on_done)
  notify('Syncing config to ' .. host.name .. '...')

  -- Ensure remote config dir exists. Uses mux so this also opens the mux socket.
  local mkdir_cmd = string.format(
    'ssh %s %s "mkdir -p %s"',
    ssh_mux_opts(host),
    ssh_target(host),
    M.config.remote_config_path
  )
  log_cmd(mkdir_cmd)

  vim.fn.jobstart(mkdir_cmd, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          line = line:gsub('\r', '')
          if line ~= '' then log('mkdir: ' .. line) end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          line = line:gsub('\r', '')
          if line ~= '' then
            notify('ssh mkdir stderr: ' .. line, vim.log.levels.ERROR)
          end
        end
      end
    end,
    on_exit = function(_, mkdir_code)
      if mkdir_code ~= 0 then
        notify(
          'Cannot create remote config dir (exit ' .. mkdir_code .. '). See :RemoteNativeLog',
          vim.log.levels.ERROR
        )
        return
      end

      -- Reuse the mux connection for rsync via -e
      local mux = ssh_mux_opts(host)
      local rsync_ssh = mux ~= '' and ('-e ' .. shell_quote('ssh ' .. mux)) or ''
      local cmd = string.format(
        'rsync -az --delete %s %s %s/ %s:%s/',
        build_excludes(),
        rsync_ssh,
        vim.fn.stdpath 'config',
        ssh_target(host),
        M.config.remote_config_path
      )
      log_cmd(cmd)

      vim.fn.jobstart(cmd, {
        on_stderr = function(_, data)
          if data then
            for _, line in ipairs(data) do
              line = line:gsub('\r', '')
              if line ~= '' then notify('rsync: ' .. line, vim.log.levels.WARN) end
            end
          end
        end,
        on_exit = function(_, code)
          if code ~= 0 then
            notify('Config sync failed (rsync exit ' .. code .. ').', vim.log.levels.ERROR)
            return
          end
          notify('Config synced.')
          on_done()
        end,
      })
    end,
  })
end

-- =============================================================================
-- STEP 2 - BOOTSTRAP REMOTE
-- Installs nvim + node + tmux if missing or wrong version.
-- Detects remote architecture (x86_64 / aarch64).
-- Idempotent: safe to run on every connect.
-- Script is piped via stdin to avoid SSH quoting issues.
-- =============================================================================

local function build_bootstrap_script()
  local v       = vim.version()
  local version = string.format('v%d.%d.%d', v.major, v.minor, v.patch)
  local node    = M.config.node_version

  return string.format([[
#!/bin/sh
set -e
mkdir -p ~/.local/bin ~/.local/lib
export PATH="$HOME/.local/bin:$PATH"

ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64)   NVIM_ARCH="x86_64";  NODE_ARCH="x64"   ;;
  aarch64|arm64)  NVIM_ARCH="aarch64"; NODE_ARCH="arm64"  ;;
  *) echo "[bootstrap] Unsupported architecture: $ARCH"; exit 1 ;;
esac

# --- TMUX ---
if ! command -v tmux >/dev/null 2>&1; then
  echo "[bootstrap] Installing tmux..."
  if   command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y -qq tmux
  elif command -v dnf     >/dev/null 2>&1; then sudo dnf install -y tmux
  elif command -v yum     >/dev/null 2>&1; then sudo yum install -y tmux
  elif command -v pacman  >/dev/null 2>&1; then sudo pacman -Sy --noconfirm tmux
  elif command -v apk     >/dev/null 2>&1; then sudo apk add tmux
  else echo "[bootstrap] WARN: no package manager found, tmux not installed"
  fi
else
  echo "[bootstrap] tmux: $(tmux -V)"
fi

# --- NEOVIM ---
NVIM_TARGET="%s"
INSTALLED=$(~/.local/bin/nvim --version 2>/dev/null | head -1 \
  | sed -n 's/.*\(v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')
INSTALLED="${INSTALLED:-none}"
if [ "$INSTALLED" != "$NVIM_TARGET" ]; then
  echo "[bootstrap] Installing nvim $NVIM_TARGET for $NVIM_ARCH (found: $INSTALLED)..."
  curl -fL "https://github.com/neovim/neovim/releases/download/${NVIM_TARGET}/nvim-linux-${NVIM_ARCH}.tar.gz" \
    -o /tmp/nvim.tar.gz
  tar -xf /tmp/nvim.tar.gz --strip-components=1 -C ~/.local/
  rm -f /tmp/nvim.tar.gz
  echo "[bootstrap] nvim: $(~/.local/bin/nvim --version | head -1)"
else
  echo "[bootstrap] nvim: $INSTALLED (matches target)"
fi

# --- NODE ---
NODE_TARGET="%s"
NODE_INSTALLED=$(~/.local/bin/node --version 2>/dev/null || echo none)
if [ "$NODE_INSTALLED" = "none" ] || [ "$NODE_INSTALLED" != "$NODE_TARGET" ]; then
  echo "[bootstrap] Installing node $NODE_TARGET for $NODE_ARCH..."
  curl -fL "https://nodejs.org/dist/${NODE_TARGET}/node-${NODE_TARGET}-linux-${NODE_ARCH}.tar.xz" \
    | tar -xJ --strip-components=1 -C ~/.local/
  echo "[bootstrap] node: $(~/.local/bin/node --version)"
else
  echo "[bootstrap] node: $NODE_INSTALLED (matches target)"
fi

# --- LAZY PLUGIN RESTORE ---
if [ "%s" = "true" ]; then
  echo "[bootstrap] Running Lazy restore..."
  ~/.local/bin/nvim --headless "+Lazy! restore" +qa 2>/dev/null || true
  echo "[bootstrap] Plugins restored."
fi

echo "[bootstrap] Done."
]], version, node, tostring(M.config.sync_plugins))
end

local function bootstrap_remote(host, on_done)
  local v       = vim.version()
  local version = string.format('v%d.%d.%d', v.major, v.minor, v.patch)
  notify('Bootstrapping ' .. host.name .. ' (nvim ' .. version .. ')...')

  local script = build_bootstrap_script()

  local cmd = string.format('ssh %s %s "sh -s"', ssh_mux_opts(host), ssh_target(host))
  log_cmd(cmd)
  log('Bootstrap script: ' .. #script .. ' bytes')

  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          line = line:gsub('\r', '')
          if line ~= '' then notify(line) end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          line = line:gsub('\r', '')
          if line ~= '' then notify('bootstrap stderr: ' .. line, vim.log.levels.WARN) end
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        notify('Bootstrap failed (exit ' .. code .. '). See :RemoteNativeLog', vim.log.levels.ERROR)
        return
      end
      notify('Remote ready.')
      on_done()
    end,
  })

  if job_id > 0 then
    vim.fn.chansend(job_id, script)
    vim.fn.chanclose(job_id, 'stdin')
  else
    notify('Failed to start SSH for bootstrap.', vim.log.levels.ERROR)
  end
end

-- =============================================================================
-- STEP 3 - OPEN REMOTE SESSION
--
-- Local side: new tmux window (Linux) or new Windows Terminal tab (WSL).
-- Remote side: attach existing tmux session or create new one with nvim.
--              Falls back to plain "nvim ." if tmux is not on the remote.
-- =============================================================================

--- Build the shell command the remote machine will execute.
--- Uses single-quoted path to handle spaces/special chars.
local function build_remote_cmd(host, path)
  local session  = host.alias:gsub('[^%w_-]', '_')
  local qpath    = shell_quote(path)

  return string.format(
    'export PATH=$HOME/.local/bin:$PATH; '
    .. 'if command -v tmux >/dev/null 2>&1; then '
    ..   'tmux has-session -t %s 2>/dev/null '
    ..   '&& tmux attach-session -t %s '
    ..   '|| tmux new-session -s %s -c %s "nvim .; exec $SHELL"; '
    .. 'else '
    ..   'cd %s && exec nvim .; '
    .. 'fi',
    session, session, session, qpath, qpath
  )
end

--- Open session in a new tmux window.
--- Works both when inside tmux ($TMUX set) and when tmux is installed but
--- the current shell is not inside a session (creates a new detached session
--- and switches client if possible; otherwise spawns xterm/gnome-terminal).
local function open_session_tmux(host, path)
  local remote_cmd = build_remote_cmd(host, path)
  local ssh_cmd    = string.format('ssh -t %s %s',
    ssh_target(host),
    vim.fn.shellescape(remote_cmd)
  )
  local window_name = host.alias .. ':' .. path

  if vim.env.TMUX and vim.env.TMUX ~= '' then
    -- Inside a local tmux session: open a new window
    local ok = vim.fn.jobstart({
      'tmux', 'new-window', '-n', window_name, ssh_cmd,
    }, { detach = 1 })
    if ok > 0 then
      notify('Opened tmux window: ' .. window_name)
    else
      notify('Failed to open tmux window.', vim.log.levels.ERROR)
    end
  else
    -- Not inside tmux: create a new detached session and attach in a terminal
    local session_name = 'nr-' .. host.alias:gsub('[^%w_-]', '_')
    -- Try common terminal emulators
    local terms = {
      { 'gnome-terminal', '--', 'tmux', 'new-session', '-s', session_name, ssh_cmd },
      { 'xterm', '-e', 'tmux', 'new-session', '-s', session_name, ssh_cmd },
      { 'kitty', '--', 'tmux', 'new-session', '-s', session_name, ssh_cmd },
      { 'alacritty', '-e', 'tmux', 'new-session', '-s', session_name, ssh_cmd },
      { 'wezterm', 'start', '--', 'tmux', 'new-session', '-s', session_name, ssh_cmd },
    }
    local launched = false
    for _, term_cmd in ipairs(terms) do
      if vim.fn.executable(term_cmd[1]) == 1 then
        vim.fn.jobstart(term_cmd, { detach = 1 })
        notify('Opened ' .. term_cmd[1] .. ' with tmux session: ' .. session_name)
        launched = true
        break
      end
    end
    if not launched then
      notify(
        'No terminal emulator found and not inside tmux. '
        .. 'Run neovim inside a tmux session, or install gnome-terminal/xterm/kitty.',
        vim.log.levels.ERROR
      )
    end
  end
end

--- Open session in a new Windows Terminal tab (WSL).
---
--- Quoting chain: Lua -> Linux /bin/sh -> cmd.exe -> wt -> wsl.exe -> bash -> SSH
--- To survive all layers we write the SSH invocation to a temp script and pass
--- only a plain file path to Windows Terminal, sidestepping cmd.exe quoting entirely.
---
--- We use `wsl.exe` instead of a --profile name so we never have to guess the
--- exact profile string configured in Windows Terminal settings.
local function open_session_wt(host, path)
  local remote_cmd = build_remote_cmd(host, path)

  -- Write SSH invocation to a temp script (plain path = no quoting needed downstream)
  local script_name = string.format('nr-%s.sh', host.alias:gsub('[^%w_-]', '_'))
  local script_path = '/tmp/' .. script_name
  local f = io.open(script_path, 'w')
  if not f then
    notify('Cannot write temp script: ' .. script_path, vim.log.levels.ERROR)
    return
  end
  f:write('#!/bin/sh\n')
  f:write(string.format('exec ssh -t %s %s\n',
    vim.fn.shellescape(ssh_target(host)),
    vim.fn.shellescape(remote_cmd)))
  f:close()
  vim.fn.system('chmod +x ' .. vim.fn.shellescape(script_path))
  log('Temp script: ' .. script_path)

  -- Build wt command.
  -- -w last  = reuse the most-recently-focused WT window (no new window spam).
  -- wsl.exe  = always routes to WSL regardless of profile name.
  -- -d DISTRO is optional: omit to use the default distro.
  local wsl_args = 'wsl.exe'
  if M.config.wt_distro and M.config.wt_distro ~= '' then
    wsl_args = 'wsl.exe -d ' .. M.config.wt_distro
  end

  -- The script path is a WSL path (/tmp/...) which wsl.exe can resolve directly.
  -- Double-quote the path in case the user's WSL username has spaces.
  -- The surrounding single quotes are for the Linux /bin/sh layer;
  -- cmd.exe will see: wt -w last new-tab -- wsl.exe bash "/tmp/nr-host.sh"
  local wt_cmd = string.format(
    [[cmd.exe /c wt -w last new-tab -- %s bash "/tmp/%s"]],
    wsl_args,
    script_name
  )
  log_cmd(wt_cmd)

  local ok = os.execute(wt_cmd)
  if ok then
    notify('Opened Windows Terminal tab: ' .. host.alias .. ':' .. path)
  else
    notify('Failed to open Windows Terminal tab. See :RemoteNativeLog', vim.log.levels.ERROR)
  end
end

local function open_session(host, path)
  local mode = detect_terminal_mode()
  if mode == 'wt' then
    open_session_wt(host, path)
  elseif mode == 'tmux' then
    open_session_tmux(host, path)
  else
    notify(
      'No supported terminal found. '
      .. 'Run neovim inside a tmux session, or use WSL with Windows Terminal.',
      vim.log.levels.ERROR
    )
  end
end

-- =============================================================================
-- PATH PICKER
-- =============================================================================

local function pick_path(host, on_done)
  local saved = get_host_paths(host.ip)

  if #saved > 0 then
    local items = { 'New path...' }
    for _, p in ipairs(saved) do table.insert(items, p) end

    vim.ui.select(items, {
      prompt = 'Open folder on ' .. host.name .. ':',
    }, function(choice)
      if not choice then return end
      if choice == 'New path...' then
        local path = vim.fn.input { prompt = 'Remote path: ', default = '~/' }
        if path and path ~= '' then on_done(path) end
      else
        on_done(choice)
      end
    end)
  else
    local path = vim.fn.input {
      prompt  = 'Folder on ' .. host.name .. ': ',
      default = '~/',
    }
    if path and path ~= '' then on_done(path) end
  end
end

-- =============================================================================
-- MAIN FLOW - host > path > sync > bootstrap > open session
-- =============================================================================

function M.open()
  local hosts = get_hosts()
  if #hosts == 0 then return end

  local mode = detect_terminal_mode()
  if not mode then
    notify(
      'No supported terminal found. '
      .. 'Run neovim inside a tmux session, or use WSL with Windows Terminal.',
      vim.log.levels.ERROR
    )
    return
  end

  vim.ui.select(hosts, {
    prompt = 'Select Remote Host:',
    format_item = function(h)
      local display = h.alias
      if h.ip ~= h.alias then display = display .. '  (' .. h.ip .. ')' end
      if h.user then display = display .. '  [' .. h.user .. ']' end
      return display
    end,
  }, function(host)
    if not host then return end

    pick_path(host, function(path)
      save_host_path(host.ip, path)
      log_session_start(host, path)

      sync_config(host, function()
        bootstrap_remote(host, function()
          open_session(host, path)
        end)
      end)
    end)
  end)
end

-- =============================================================================
-- SYNC ONLY
-- =============================================================================

function M.sync_only()
  local hosts = get_hosts()
  if #hosts == 0 then return end

  vim.ui.select(hosts, {
    prompt = 'Sync config to:',
    format_item = function(h) return h.alias end,
  }, function(host)
    if not host then return end
    notify('Syncing config to ' .. host.name .. '...')
    sync_config(host, function()
      notify('Done. Restart nvim on remote to apply changes.')
    end)
  end)
end

-- =============================================================================
-- STATUS - check versions on all hosts in parallel
-- =============================================================================

function M.status()
  local hosts = get_hosts()
  if #hosts == 0 then return end
  notify('Checking ' .. #hosts .. ' host(s)...')

  local status_script = [[
export PATH=$HOME/.local/bin:$PATH
printf "nvim:%s\n"  "$(nvim  --version 2>/dev/null | head -1 || echo NOT_INSTALLED)"
printf "tmux:%s\n"  "$(tmux  -V        2>/dev/null           || echo NOT_INSTALLED)"
printf "node:%s\n"  "$(node  --version 2>/dev/null           || echo NOT_INSTALLED)"
printf "arch:%s\n"  "$(uname -m)"
]]

  for _, host in ipairs(hosts) do
    local cmd = string.format('ssh %s %s "sh -s"', ssh_mux_opts(host), ssh_target(host))
    local output = {}

    local job_id = vim.fn.jobstart(cmd, {
      on_stdout = function(_, data)
        if data then
          for _, line in ipairs(data) do
            line = line:gsub('\r', '')
            if line ~= '' then table.insert(output, line) end
          end
        end
      end,
      on_exit = function(_, code)
        if code ~= 0 then
          notify(host.alias .. ': unreachable', vim.log.levels.WARN)
        else
          notify(host.alias .. ':  ' .. table.concat(output, '  '))
        end
      end,
    })

    if job_id > 0 then
      vim.fn.chansend(job_id, status_script)
      vim.fn.chanclose(job_id, 'stdin')
    end
  end
end

-- =============================================================================
-- CLEANUP - wipe remote nvim install
-- =============================================================================

function M.cleanup()
  local hosts = get_hosts()
  if #hosts == 0 then return end

  vim.ui.select(hosts, {
    prompt = 'Cleanup on:',
    format_item = function(h) return h.alias end,
  }, function(host)
    if not host then return end

    vim.ui.select(
      { 'Config only', 'Full install (nvim + plugins + config)', 'Cancel' },
      { prompt = 'What to wipe on ' .. host.name .. ':' },
      function(choice)
        if not choice or choice == 'Cancel' then return end

        local cmd_str
        if choice == 'Config only' then
          cmd_str = 'rm -rf ' .. M.config.remote_config_path
        else
          cmd_str = 'rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.local/bin/nvim'
        end

        vim.fn.jobstart(
          string.format('ssh %s %s %s', ssh_mux_opts(host), ssh_target(host), vim.fn.shellescape(cmd_str)),
          {
            on_exit = function(_, code)
              close_mux(host)  -- close mux socket after cleanup
              notify(
                code == 0 and 'Cleaned up ' .. host.alias
                          or  'Cleanup failed on ' .. host.alias .. ' (exit ' .. code .. ')',
                code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
              )
            end,
          }
        )
      end
    )
  end)
end

-- =============================================================================
-- ADD HOST - appends block to ~/.ssh/config
-- =============================================================================

function M.add_host()
  local alias    = vim.fn.input 'Host alias: '
  if alias == '' then return end
  local hostname = vim.fn.input 'IP or domain: '
  if hostname == '' then return end
  local user     = vim.fn.input 'User (leave empty to skip): '
  local key      = vim.fn.input 'IdentityFile (leave empty to skip): '

  local lines = { '', 'Host ' .. alias, '    HostName ' .. hostname }
  if user ~= '' then lines[#lines + 1] = '    User ' .. user end
  if key  ~= '' then lines[#lines + 1] = '    IdentityFile ' .. key end
  lines[#lines + 1] = ''

  local f = io.open(vim.fn.expand(M.config.ssh_config_path), 'a')
  if not f then
    notify('Cannot write to ' .. M.config.ssh_config_path, vim.log.levels.ERROR)
    return
  end
  f:write(table.concat(lines, '\n'))
  f:close()
  notify('Added "' .. alias .. '" to ' .. M.config.ssh_config_path)
end

-- =============================================================================
-- COMMANDS
-- =============================================================================

vim.api.nvim_create_user_command('RemoteNative', M.open, {
  desc = 'Connect to remote host (sync + bootstrap + open session)',
})
vim.api.nvim_create_user_command('RemoteNativeSync', M.sync_only, {
  desc = 'Sync nvim config to remote host',
})
vim.api.nvim_create_user_command('RemoteNativeStatus', M.status, {
  desc = 'Check nvim/tmux/node versions on all hosts',
})
vim.api.nvim_create_user_command('RemoteNativeCleanup', M.cleanup, {
  desc = 'Wipe remote nvim install',
})
vim.api.nvim_create_user_command('RemoteNativeAdd', M.add_host, {
  desc = 'Add host to ~/.ssh/config',
})
vim.api.nvim_create_user_command('RemoteNativeLog', function()
  if vim.fn.filereadable(log_file) == 0 then
    local f = io.open(log_file, 'w')
    if f then f:write('-- NativeRemote log --\n'); f:close() end
  end
  vim.cmd('split ' .. vim.fn.fnameescape(log_file))
  vim.cmd 'setlocal autoread nomodifiable'
  vim.cmd 'normal! G'
end, {
  desc = 'Open NativeRemote log file',
})
vim.api.nvim_create_user_command('RemoteNativeLogClear', function()
  local f = io.open(log_file, 'w')
  if f then
    f:write('-- NativeRemote log cleared ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' --\n')
    f:close()
  end
  notify('Log cleared.')
end, {
  desc = 'Clear the NativeRemote log file',
})

return M
