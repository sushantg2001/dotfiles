local map = vim.keymap.set
local wk = require 'which-key'

local function r(fn)
  return function() require('core.remote')[fn]() end
end

wk.add {
  { '<leader>r', group = '[R]emote' },
}

map('n', '<leader>ro', r 'open', { desc = '[R]emote [O]pen session' })
map('n', '<leader>rs', r 'sync_only', { desc = '[R]emote [S]ync config' })
map('n', '<leader>ri', r 'status', { desc = '[R]emote [I]nfo / status' })
map('n', '<leader>rk', r 'cleanup', { desc = '[R]emote [K]ill / cleanup' })
map('n', '<leader>ra', r 'add_host', { desc = '[R]emote [A]dd host' })

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
