local map = vim.keymap.set

map('n', '<leader>rc', '<cmd>RemoteStart<cr>', { desc = '[R]emote [C]onnect' })
map('n', '<leader>rx', '<cmd>RemoteStop<cr>', { desc = '[R]emote disconnect [X]' })
map('n', '<leader>ri', '<cmd>RemoteInfo<cr>', { desc = '[R]emote [I]nfo' })
map('n', '<leader>rl', '<cmd>RemoteLog<cr>', { desc = '[R]emote [L]og' })
map('n', '<leader>rk', '<cmd>RemoteCleanup<cr>', { desc = '[R]emote [K]ill + cleanup' })
map('n', '<leader>rt', '<cmd>RemoteTerminal<cr>', { desc = 'Remote Terminal' })

local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then return end
map('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', telescope.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', telescope.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = '[S]earch [T]odos' })
map(
  'n',
  '<leader>s/',
  function()
    telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end,
  { desc = '[S]earch [/] in current buffer' }
)
