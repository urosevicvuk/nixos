# Debug Adapter Protocol (DAP) configuration
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      nvim-dap-ui
      nvim-dap-virtual-text
    ];

    # Configure DAP UI
    luaConfigRC.dap-ui = ''
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Auto-open DAP UI
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    '';

    # Configure DAP Virtual Text
    luaConfigRC.dap-virtual-text = ''
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        virt_text_pos = 'eol',
      })
    '';

    keymaps = [
      # DAP UI
      {
        key = "<leader>du";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dapui').toggle()<CR>";
        desc = "Toggle DAP UI";
      }

      # Breakpoints
      {
        key = "<leader>db";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        desc = "Toggle Breakpoint";
      }
      {
        key = "<leader>dB";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        desc = "Conditional Breakpoint";
      }
      {
        key = "<leader>dL";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
        desc = "Log Point";
      }

      # Debug Control
      {
        key = "<leader>dc";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').continue()<CR>";
        desc = "Continue";
      }
      {
        key = "<leader>dC";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').run_to_cursor()<CR>";
        desc = "Run to Cursor";
      }
      {
        key = "<leader>dg";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').goto_()<CR>";
        desc = "Go to Line (no execute)";
      }

      # Step Controls
      {
        key = "<leader>di";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').step_into()<CR>";
        desc = "Step Into";
      }
      {
        key = "<leader>do";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').step_out()<CR>";
        desc = "Step Out";
      }
      {
        key = "<leader>dO";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').step_over()<CR>";
        desc = "Step Over";
      }
      {
        key = "<leader>dj";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').down()<CR>";
        desc = "Down Stack Frame";
      }
      {
        key = "<leader>dk";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').up()<CR>";
        desc = "Up Stack Frame";
      }

      # Session Control
      {
        key = "<leader>dp";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').pause()<CR>";
        desc = "Pause";
      }
      {
        key = "<leader>dr";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').repl.toggle()<CR>";
        desc = "Toggle REPL";
      }
      {
        key = "<leader>ds";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').session()<CR>";
        desc = "Session Info";
      }
      {
        key = "<leader>dt";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap').terminate()<CR>";
        desc = "Terminate Debug Session";
      }
      {
        key = "<leader>dw";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
        desc = "Debug Hover";
      }
    ];
  };
}
