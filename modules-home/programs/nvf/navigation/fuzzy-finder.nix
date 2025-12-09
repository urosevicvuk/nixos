# Fuzzy finder - Snacks.nvim picker with all keymaps
{ ... }:
{
  programs.nvf.settings.vim = {
    # Snacks.nvim configuration
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        picker = {
          enabled = true;
        };
        explorer = {
          enabled = true;
        };
      };
    };

    keymaps = [
      # Quick access shortcuts (in addition to leader+f+X)
      {
        key = "<leader><space>";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.files()<cr>";
        desc = "Find files (quick)";
      }
      {
        key = "<leader>/";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Grep (quick)";
      }
      {
        key = "<leader>,";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Buffers (quick)";
      }
      {
        key = "<leader>:";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.command_history()<cr>";
        desc = "Command history";
      }
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.explorer()<cr>";
        desc = "Explorer (quick)";
      }

      # File and buffer navigation
      {
        key = "<leader>ff";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.files()<cr>";
        desc = "Find files";
      }
      {
        key = "<leader>fa";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.files({ hidden = true })<cr>";
        desc = "Find all files (including hidden)";
      }
      {
        key = "<leader>fb";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Find buffers";
      }
      {
        key = "<leader>fo";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        desc = "Recent files";
      }
      {
        key = "<leader>fe";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.explorer()<cr>";
        desc = "Snacks explorer";
      }
      {
        key = "<leader>fO";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('oil').open_float()<cr>";
        desc = "Oil (buffer-based)";
      }
      {
        key = "-";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('oil').open()<cr>";
        desc = "Open Oil in current window";
      }

      # Search
      {
        key = "<leader>fw";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Grep word";
      }
      {
        key = "<leader>fW";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep_word()<cr>";
        desc = "Grep word under cursor";
      }
      {
        key = "<leader>fl";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lines()<cr>";
        desc = "Search lines in current buffer";
      }
      {
        key = "<leader>ft";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
        desc = "Find todos";
      }
      {
        key = "<leader>fc";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>";
        desc = "Find config files";
      }
      {
        key = "<leader>fp";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.projects()<cr>";
        desc = "Find projects";
      }
      {
        key = "<leader>fn";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.notifications()<cr>";
        desc = "Notification history";
      }
      {
        key = "<leader>fB";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
        desc = "Grep in open buffers";
      }
      {
        key = "<leader>fu";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.undo()<cr>";
        desc = "Undo history";
      }
      {
        key = "<leader>fs";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        desc = "LSP symbols (file)";
      }
      {
        key = "<leader>fS";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
        desc = "LSP symbols (workspace)";
      }

      # Git operations (file-finding related)
      {
        key = "<leader>gF";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_files()<cr>";
        desc = "Git files";
      }
      {
        key = "<leader>gb";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_branches()<cr>";
        desc = "Git branches";
      }
      {
        key = "<leader>gL";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_log()<cr>";
        desc = "Git log";
      }
      {
        key = "<leader>gf";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
        desc = "Git log (current file)";
      }
      {
        key = "<leader>gS";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_stash()<cr>";
        desc = "Git stash";
      }
      {
        key = "<leader>gs";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_status()<cr>";
        desc = "Git status";
      }
      {
        key = "<leader>gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_diff()<cr>";
        desc = "Git diff";
      }
    ];
  };
}
