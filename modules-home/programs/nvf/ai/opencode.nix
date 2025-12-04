{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [ opencode-nvim ];

    options = {
      autoread = true;
    };

    # Global configuration for opencode.nvim
    # OpenCode runs in a tmux pane - navigate seamlessly with Ctrl+h/j/k/l
    luaConfigRC.opencode = ''
      -- Provider configuration - use tmux for seamless navigation with vim-tmux-navigator
      -- OpenCode will open in a tmux pane to the right of nvim
      -- Use Ctrl+l to jump from nvim to OpenCode pane
      -- Use Ctrl+h to jump back from OpenCode to nvim
      vim.g.opencode_opts = {
        provider = {
          enabled = "tmux",
          tmux = {
            direction = "right", -- Open tmux pane to the right (can be "left", "top", "bottom")
            percent = 40, -- 40% of terminal width
          },
        },

        -- Context configuration - what gets sent to OpenCode
        context = {
          enabled = true,
          cursor_data = {
            enabled = false, -- Don't send cursor position (less noise)
          },
          diagnostics = {
            info = false,
            warn = true,
            error = true,
          },
          current_file = {
            enabled = true,
          },
          selection = {
            enabled = true,
          },
        },
      }
    '';

    keymaps = [
      # Ask OpenCode about selected code or current context
      {
        key = "<leader>oa";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<cr>";
        desc = "Ask OpenCode about this";
      }
      # Select from prompt library (review, optimize, explain, etc.)
      {
        key = "<leader>os";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').select()<cr>";
        desc = "OpenCode: Select action";
      }
      # Add current context to OpenCode prompt
      {
        key = "<leader>o+";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').prompt('@this')<cr>";
        desc = "OpenCode: Add to context";
      }
      # Toggle OpenCode window
      {
        key = "<leader>og";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').toggle()<cr>";
        desc = "OpenCode: Toggle window";
      }
      # Open input window and start typing
      {
        key = "<leader>oi";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').ask('')<cr>";
        desc = "OpenCode: Open input";
      }
      # Open output window
      {
        key = "<leader>oo";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').toggle()<cr>";
        desc = "OpenCode: Open output";
      }
      # Toggle focus between OpenCode and editor
      {
        key = "<leader>ot";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').toggle_focus()<cr>";
        desc = "OpenCode: Toggle focus";
      }
      # Close OpenCode windows
      {
        key = "<leader>oq";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').close()<cr>";
        desc = "OpenCode: Close";
      }
      # Session management
      {
        key = "<leader>oS";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').select_session()<cr>";
        desc = "OpenCode: Select session";
      }
      {
        key = "<leader>on";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session.new')<cr>";
        desc = "OpenCode: New session";
      }
      # Interrupt running OpenCode session
      {
        key = "<leader>oI";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session.interrupt')<cr>";
        desc = "OpenCode: Interrupt";
      }
      # Cycle through agents (build/plan/custom)
      {
        key = "<leader>oA";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('agent.cycle')<cr>";
        desc = "OpenCode: Cycle agent";
      }
      # Scroll through OpenCode messages
      {
        key = "<S-C-u>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session.half.page.up')<cr>";
        desc = "OpenCode: Scroll up";
      }
      {
        key = "<S-C-d>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session.half.page.down')<cr>";
        desc = "OpenCode: Scroll down";
      }
    ];
  };
}
