# ------------------------------------------------------------------
# -- WSL Helper: Safely convert Windows paths to WSL paths ---------
# ------------------------------------------------------------------
function _to_wsl_path {
    param($inputPath)
    if (-not $inputPath -or $inputPath -like "-*") { return $inputPath }
    
    try {
        # Resolve to absolute Windows path
        $absPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($inputPath)
        # Convert to WSL format, silencing the 'wslpath' info/error output
        $wslPath = wsl wslpath -u ($absPath -replace '\\', '/') 2>$null
        if ($null -ne $wslPath) { return ([string]$wslPath).Trim() }
    } catch { }
    
    return $inputPath
}

# ------------------------------------------------------------------
# -- WSL Shims (delegate Windows tools to WSL) ----------------------
# ------------------------------------------------------------------

# Editors (Path Sensitive)
function vim  { if ($args.Count -gt 0) { wsl vim  (_to_wsl_path $args[0]) } else { wsl vim  } }
function nvim { if ($args.Count -gt 0) { wsl nvim (_to_wsl_path $args[0]) } else { wsl nvim } }
function nano { if ($args.Count -gt 0) { wsl nano (_to_wsl_path $args[0]) } else { wsl nano } }

# Version Control & SSH (Path Sensitive for keys/repos)
function git         { wsl git $args }
function ssh         { wsl ssh $args }
function ssh-add     { if ($args.Count -gt 0) { wsl ssh-add (_to_wsl_path $args[0]) } else { wsl ssh-add } }
function ssh-keygen  { wsl ssh-keygen $args }
function ssh-copy-id { wsl ssh-copy-id $args }

# File Operations (Path Sensitive)
function tar  { 
    # Basic fix for 'tar -xf file.tar.gz' - translates the last argument
    $newArgs = @($args)
    if ($newArgs.Count -gt 0) { $newArgs[-1] = _to_wsl_path $newArgs[-1] }
    wsl tar $newArgs 
}
function make { wsl make $args }

# Python / Environment (pyenv shims)
function python  { wsl ~/.pyenv/shims/python $args }
function python3 { wsl ~/.pyenv/shims/python3 $args }
function pip     { wsl ~/.pyenv/shims/pip $args }
function pip3    { wsl ~/.pyenv/shims/pip3 $args }
function pyenv   { wsl ~/.pyenv/bin/pyenv $args }

# Networking & Utilities
function curl { wsl curl $args }
function wget { wsl wget $args }
function grep { wsl grep $args }
function awk  { wsl awk $args }
function sed  { wsl sed $args }

# Docker
function docker         { wsl docker $args }
function docker-compose { wsl docker compose $args }

# ------------------------------------------------------------------