return {
  'olimorris/codecompanion.nvim',
  opts = {
    interactions = {
      chat = {
        adapter = { name = 'opencode' },
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
        opencode = function()
          return require('codecompanion.adapters').extend('opencode', {
            defaults = {
              timeout = 30000,
            },
          })
        end,
      },

      openrouter = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'openrouter',
          formatted_name = 'OpenRouter',
          url = 'https://openrouter.ai/api/v1/chat/completions',
          env = {
            api_key = 'OPENROUTER_API_KEY',
          },
          schema = {
            model = {
              default = 'google/gemini-2.5-flash',
              choices = {
                'anthropic/claude-opus-4.7',
                'anthropic/claude-sonnet-4.6',
                'google/gemini-2.5-pro',
                'google/gemini-2.5-flash',
                'openai/gpt-4o-mini',
                'openai/gpt-4o-mini-search-preview',
                'mistralai/mistral-small-3.2-24b-instruct',
                'openrouter/free',
              },
            },
          },
        })
      end,
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
