-- =============================================================================
-- UI
-- VSCode-like interface layer:
--   - neo-tree: file explorer sidebar
--   - bufferline: visual tabs
--   - project.nvim: workspace/project detection
--   - dropbar.nvim: breadcrumbs in winbar
--   - nvim-notify: visual notifications
--   - noice.nvim: command line and UI polish
-- =============================================================================

return {

  -- -----------------------------------------------------------------
  -- COLORSCHEME
  -- -----------------------------------------------------------------
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- -----------------------------------------------------------------
  -- MINI.STATUSLINE - bottom status bar
  -- -----------------------------------------------------------------
  {
    'echasnovski/mini.statusline',
    version = '*',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- BUFFERLINE
  -- Dependencies:
  --   - nvim-web-devicons: file icons
  --   - scope.nvim: isolates buffers per tab page
  --   - bufdelete.nvim: smarter buffer deletion (no layout disruption)
  -- =============================================================================

  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
  },

  {
    'tiagovla/scope.nvim',
    config = function()
      -- required for scope.nvim to track buffers per tab correctly
      vim.opt.sessionoptions = { 'buffers', 'tabpages', 'globals' }

      require('scope').setup {
        restore_state = false,
      }
      -- tell telescope about scoped buffers so :Telescope buffers
      -- only shows current tab's buffers
      local ok, telescope = pcall(require, 'telescope')
      if ok then pcall(telescope.load_extension, 'scope') end
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'tiagovla/scope.nvim', -- must load before bufferline
      'famiu/bufdelete.nvim',
    },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          style_preset = require('bufferline').style_preset.default,
          themable = true,
          numbers = 'ordinal',
          close_command = 'Bdelete! %d',
          right_mouse_command = 'Bdelete! %d',
          left_mouse_command = 'buffer %d',
          indicator = { style = 'icon', icon = '?' },
          buffer_close_icon = '??',
          modified_icon = '?',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 20,
          truncate_names = true,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false, -- don't update while typing
          diagnostics_indicator = function(count, level)
            local icon = level:match 'error' and ' ' or ' '
            return ' ' .. icon .. count
          end,
          offsets = {
            {
              filetype = 'neo-tree',
              text = ' Explorer',
              text_align = 'left',
              separator = true,
            },
            {
              filetype = 'toggleterm',
              text = ' Terminal',
              text_align = 'left',
              separator = true,
            },
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true, -- shows tab number badge
          show_duplicate_prefix = true, -- show path when two files share a name
          persist_buffer_sort = true, -- remember manual reorders
          move_wraps_at_ends = true, -- wrap when moving past first/last
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = 'insert_after_current',
          separator_style = 'slant',
          groups = {
            options = { toggle_hidden_on_enter = true },
            items = {
              require('bufferline.groups').builtin.pinned:with {
                icon = '??',
              },
            },
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },
        },
      }
    end,
  },

  -- -----------------------------------------------------------------
  -- NEO-TREE - VSCode-style file explorer sidebar
  -- toggle with <leader>e
  -- -----------------------------------------------------------------
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'muniftanjim/nui.nvim',
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      require('neo-tree').setup {
        close_if_last_window = true,
        popup_border_style = 'rounded',
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        enable_git_status = true,
        enable_diagnostics = true,

        event_handlers = {
          {
            event = 'neo_tree_popup_input_ready',
            handler = function(args)
              vim.cmd 'stopinsert'
              vim.keymap.set('i', '<esc>', vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
            end,
            {
              event = 'neo_tree_buffer_enter',
              handler = function(arg)
                -- This ensures that when you are INSIDE the preview window,
                -- Esc will actually close it.
                if vim.bo[arg.bufnr].filetype == 'neo-tree-preview' then vim.keymap.set('n', '<esc>', '<cmd>q<cr>', { buffer = arg.bufnr, noremap = true }) end
              end,
            },
          },
        },

        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = '³',
            last_indent_marker = 'à',
            highlight = 'neotreeindentmarker',
            with_expanders = true,
          },
          icon = {
            folder_closed = '?',
            folder_open = '?',
            folder_empty = '??',
            default = '??',
            highlight = 'neotreefileicon',
          },
          modified = { symbol = '[+]', highlight = 'neotreemodified' },
          git_status = {
            symbols = {
              added = '?',
              modified = '?',
              deleted = '?',
              renamed = '??',
              untracked = '?',
              ignored = '?',
              unstaged = '??',
              staged = '?',
              conflict = '?',
            },
          },
        },

        window = {
          position = 'left',
          width = 35,
          mapping_options = { noremap = true, nowait = true },
        },

        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { '.git', 'node_modules', '__pycache__' },
            always_show = { '.env', '.gitignore' },
          },
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = 'open_current',
          use_libuv_file_watcher = true,
        },
      }
    end,
  },

  -- -----------------------------------------------------------------
  -- PROJECT.NVIM - workspace/project detection
  -- detects project root from .git, package.json, pyproject.toml etc.
  -- integrates with telescope and neo-tree
  -- :Telescope projects picker for all known projects
  -- -----------------------------------------------------------------
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        -- detection methods in order
        detection_methods = { 'lsp', 'pattern' },

        -- project root markers
        patterns = {
          '.git',
          'package.json',
          'pyproject.toml',
          'setup.py',
          'Cargo.toml',
          'go.mod',
          'Makefile',
          'docker-compose.yml',
          '.terraform',
          'requirements.txt',
          'flake.nix',
        },

        -- change directory behaviour
        scope_chdir = 'global', -- cd globally when project detected
        manual_mode = false, -- auto-detect, don't wait for command

        -- show_hidden = false means .git dirs aren't shown in project list
        show_hidden = false,

        -- don't auto cd into subdirs of a project
        exclude_dirs = {
          '~/.cargo',
          '~/.local',
          '~/.npm',
        },

        -- silent project changes (no echo message)
        silent_chdir = true,
      }

      -- register with telescope so :Telescope projects works
      local ok, telescope = pcall(require, 'telescope')
      if ok then pcall(telescope.load_extension, 'projects') end
    end,
  },

  -- -----------------------------------------------------------------
  -- DROPBAR.NVIM - breadcrumbs in winbar (like VSCode's path bar)
  -- shows: filename > function > block at top of every window
  -- click any segment to jump to it
  -- -----------------------------------------------------------------
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require('dropbar').setup {
        -- general is deprecated - enable moved to bar.enable
        bar = {
          -- only attach to normal file buffers
          enable = function(buf, win, _)
            return vim.api.nvim_buf_is_valid(buf)
              and vim.api.nvim_win_is_valid(win)
              and vim.bo[buf].buftype == ''
              and vim.bo[buf].filetype ~= 'neo-tree'
              and vim.bo[buf].filetype ~= 'toggleterm'
          end,
          -- show source: file path + symbols
          sources = function(buf, _)
            local sources = require 'dropbar.sources'
            local utils = require 'dropbar.utils'
            if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
            if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
            return {
              sources.path,
              utils.source.fallback {
                sources.lsp,
                sources.treesitter,
              },
            }
          end,
        },
        icons = {
          enable = true,
          kinds = {
            -- use_devicons is deprecated
            -- file and folder icons now configured separately
            file_icon = function(path, buf)
              local ok, devicons = pcall(require, 'nvim-web-devicons')
              if not ok then return '' end
              local icon, hl = devicons.get_icon(vim.fn.fnamemodify(path, ':t'), vim.fn.fnamemodify(path, ':e'), { default = true })
              return icon or '', hl
            end,
          },
        },
      }
    end,
  },

  -- -----------------------------------------------------------------
  -- NVIM-NOTIFY - visual popup notifications
  -- replaces vim's bottom echo messages with styled popups
  -- -----------------------------------------------------------------
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        background_colour = '#000000',
        fps = 60,
        icons = {
          DEBUG = '',
          ERROR = '',
          INFO = '',
          TRACE = '?',
          WARN = '',
        },
        level = 2,
        minimum_width = 50,
        render = 'compact', -- 'default'|'minimal'|'simple'|'compact'
        stages = 'slide', -- 'fade'|'slide'|'fade_in_slide_out'|'static'
        timeout = 3000,
        top_down = false, -- show from bottom right like VSCode
      }
      -- replace default vim.notify with nvim-notify
      vim.notify = notify
    end,
  },
  {
    'folke/zen-mode.nvim',
    opts = {
      window = { width = 0.85 }, -- width is 85% of editor width
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        -- -----------------------------------------------------------------
        -- SIZE
        -- for horizontal: number of rows
        -- for vertical: proportion of window width
        -- can also be a function: size = function(term)
        --   if term.direction == 'horizontal' then return 15
        --   elseif term.direction == 'vertical' then return vim.o.columns * 0.4
        --   end
        -- end
        -- -----------------------------------------------------------------
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
          end
        end,

        -- -----------------------------------------------------------------
        -- OPEN / CLOSE
        -- open_mapping triggers the default terminal toggle
        -- mapped in keymaps/ui.lua to <C-\> and <A-q>
        -- -----------------------------------------------------------------
        hide_numbers = true, -- hide line numbers in terminal
        shade_terminals = true, -- slightly shade terminal bg
        shading_factor = 2, -- how much to shade (1-3)
        start_in_insert = true, -- enter insert mode when opening
        insert_mappings = true, -- open_mapping works in insert mode
        terminal_mappings = true, -- open_mapping works in terminal mode
        persist_size = true, -- remember terminal size
        persist_mode = true, -- remember terminal mode (insert/normal)
        close_on_exit = true, -- close terminal window when process exits
        auto_scroll = true, -- scroll to bottom on new output

        -- -----------------------------------------------------------------
        -- DIRECTION
        -- 'horizontal' | 'vertical' | 'float' | 'tab'
        -- default for <C-\> toggle - lazygit uses float (see keymaps/git.lua)
        -- -----------------------------------------------------------------
        direction = 'horizontal',

        -- -----------------------------------------------------------------
        -- SHELL
        -- defaults to vim.o.shell - override per OS if needed
        -- -----------------------------------------------------------------
        shell = vim.o.shell,

        -- -----------------------------------------------------------------
        -- FLOAT SETTINGS
        -- used when direction = 'float'
        -- -----------------------------------------------------------------
        float_opts = {
          border = 'curved', -- 'single'|'double'|'shadow'|'curved'
          width = math.floor(vim.o.columns * 0.85),
          height = math.floor(vim.o.lines * 0.85),
          winblend = 3, -- transparency (0 = opaque, 100 = invisible)
        },

        -- -----------------------------------------------------------------
        -- WINBAR
        -- show terminal name in winbar (nvim 0.8+)
        -- -----------------------------------------------------------------
        winbar = {
          enabled = true,
          name_formatter = function(term) return string.format('%d: %s', term.id, term.name) end,
        },
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'codecompanion' },

    config = function()
      local orig_get_node_text = vim.treesitter.get_node_text
      vim.treesitter.get_node_text = function(node, source, opts)
        if not node then return '' end
        if type(node) == 'table' and node[1] ~= nil then node = node[1] end
        if type(node) ~= 'userdata' or type(node.range) ~= 'function' then return '' end
        local ok, result = pcall(orig_get_node_text, node, source, opts)
        return ok and result or ''
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'codecompanion' },
        callback = function() vim.opt_local.conceallevel = 2 end,
      })
    end,
  },
}
