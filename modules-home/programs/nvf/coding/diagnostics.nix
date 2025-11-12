# Diagnostics and linting
{ lib, pkgs, ... }:
{
  programs.nvf.settings.vim = {
    diagnostics = {
      enable = true;
      config = {
        signs = {
          text = {
            "vim.diagnostic.severity.Error" = " ";
            "vim.diagnostic.severity.Warn" = " ";
            "vim.diagnostic.severity.Hint" = " ";
            "vim.diagnostic.severity.Info" = " ";
          };
        };
        underline = true;
        update_in_insert = true;
        virtual_text = {
          format =
            lib.generators.mkLuaInline
              # lua
              ''
                function(diagnostic)
                  return string.format("%s", diagnostic.message)
                  --return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                end
              '';
        };
      };
      nvim-lint = {
        enable = true;
      };
    };

    # Trouble.nvim - Better diagnostics/quickfix/location list
    lsp.trouble.enable = true;

    # Todo-comments - Highlight TODO/FIXME/NOTE/etc
    startPlugins = with pkgs.vimPlugins; [
      todo-comments-nvim
    ];

    luaConfigRC.todo-comments = ''
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      })
    '';

    keymaps = [
      # Trouble keybinds
      {
        key = "<leader>xx";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Toggle Trouble";
      }
      {
        key = "<leader>xd";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        desc = "Document Diagnostics";
      }
      {
        key = "<leader>xw";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Workspace Diagnostics";
      }
      {
        key = "<leader>xq";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble qflist toggle<cr>";
        desc = "Quickfix List";
      }
      {
        key = "<leader>xl";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble loclist toggle<cr>";
        desc = "Location List";
      }
    ];
  };
}
