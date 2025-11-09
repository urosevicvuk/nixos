# Testing framework - Neotest
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      neotest
      neotest-plenary
    ];

    luaConfigRC.neotest = ''
      require("neotest").setup({
        adapters = {
          require("neotest-plenary"),
        },
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
        },
      })
    '';

    keymaps = [
      {
        key = "<leader>tr";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').run.run()<CR>";
        desc = "Run Nearest Test";
      }
      {
        key = "<leader>tf";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
        desc = "Run File Tests";
      }
      {
        key = "<leader>ts";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').summary.toggle()<CR>";
        desc = "Toggle Test Summary";
      }
      {
        key = "<leader>to";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('neotest').output.open({ enter = true })<CR>";
        desc = "Show Test Output";
      }
    ];
  };
}
