local map = vim.keymap.set
local wk = require 'which-key'

map('n', '<leader>rc', '<cmd>RemoteStart<cr>', { desc = '[R]emote [C]onnect' })
map('n', '<leader>rx', '<cmd>RemoteStop<cr>', { desc = '[R]emote disconnect [X]' })
map('n', '<leader>ri', '<cmd>RemoteInfo<cr>', { desc = '[R]emote [I]nfo' })
map('n', '<leader>rl', '<cmd>RemoteLog<cr>', { desc = '[R]emote [L]og' })
map('n', '<leader>rk', '<cmd>RemoteCleanup<cr>', { desc = '[R]emote [K]ill + cleanup' })
map('n', '<leader>rt', '<cmd>RemoteTerminal<cr>', { desc = 'Remote Terminal' })

wk.add {
  { '<leader>s', group = '[S]Hop' },

  { '<leader>sw', '<cmd>hopword<cr>', desc = 'hop to word' },
  { '<leader>se', '<cmd>hopwordAC<cr>', desc = 'hop to word' },
  { '<leader>sb', '<cmd>hopwordBC<cr>', desc = 'hop to word' },

  -- Line hops
  { '<leader>sl', '<cmd>HopLine<cr>', desc = 'Hope line' },
  { '<leader>sj', '<cmd>HopLineAC<cr>', desc = 'Hope line' },
  { '<leader>sk', '<cmd>HopLineBC<cr>', desc = 'Hope line' },

  -- Charactes hops
  { '<leader>ss', '<cmd>HopChar<cr>', desc = 'Hop to char' },
  { '<leader>sS', '<cmd>HopChar2<cr>', desc = 'Hop to char' },
  { '<leader>st', '<cmd>HopChar1BC<cr>', desc = 'Hop to char' },
  { '<leader>sf', '<cmd>HopChar1AC<cr>', desc = 'Hop to char' },
  { '<leader>sT', '<cmd>HopChar2BC<cr>', desc = 'Hop to char' },
  { '<leader>sF', '<cmd>HopChar2AC<cr>', desc = 'Hop to char' },
  { '<leader>sp', '<cmd>HopPattern<cr>', desc = 'Hop to pattern' },
  { '<leader>sv', '<cmd>HopVertical<cr>', desc = 'Hop vertical' },
}
