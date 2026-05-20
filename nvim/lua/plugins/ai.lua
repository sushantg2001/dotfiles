local function get_openrouter_key()
  local key = os.getenv 'OPENROUTER_API_KEY'
  if key and key ~= '' then return key end
  local env_path = vim.fn.expand '~/dotfiles/claude/.env'
  local file = io.open(env_path, 'r')
  if file then
    for line in file:lines() do
      local match = line:match '^OPENROUTER_API_KEY=(.*)$'
      if match then
        file:close()
        return match:gsub('["\']', '')
      end
    end
    file:close()
  end
  return 'KEY_NOT_FOUND'
end

return {
  'olimorris/codecompanion.nvim',

  opts = {

    interactions = {
      chat = {
        adapter = { name = 'claude_code' },
      },
      inline = {
        adapter = 'openrouter',
      },
      cmd = {
        adapter = 'openrouter',
      },
      background = {
        adapter = 'openrouter',
      },
    },

    adapters = {
      acp = {
        claude_code = function()
          return require('codecompanion.adapters').extend('claude_code', {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = 'ANTHROPIC_AUTH_TOKEN',
            },
          })
        end,
      },
      http = {
        openrouter = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://openrouter.ai/api',
              api_key = get_openrouter_key(),
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                default = 'anthropic/claude-haiku-4.5',
              },
            },
          })
        end,
      },
    },

    display = {
      chat = {
        show_token_count = true,
        render_headers = true,
      },
      diff = {
        provider = 'mini_diff',
      },
    },
  },
}
