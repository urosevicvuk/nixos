# Git integration - Using Snacks.nvim (Folke's preference)
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    # Using Snacks.nvim for git signs (Folke's plugin wins)
    # Removed: gitsigns.nvim, mini.git
    # Using Snacks gitsigns and git features from snacks.nvim

    utility.snacks-nvim.setupOpts = {
      gitsigns = {
        enabled = true;
      };
    };

    # mini.diff for diff view (complementary, not conflicting)
    # Loaded via mini.nix

    # Git blame functionality
    startPlugins = with pkgs.vimPlugins; [
      git-blame-nvim
    ];

    globals = {
      gitblame_enabled = false; # Start disabled, toggle with keybind
      gitblame_message_template = "<author> • <date> • <summary>";
      gitblame_date_format = "%r";
      gitblame_display_virtual_text = true;
    };

    keymaps = [
      {
        key = "<leader>gB";
        mode = "n";
        silent = true;
        action = "<cmd>GitBlameToggle<cr>";
        desc = "Toggle Git Blame";
      }
      {
        key = "<leader>gO";
        mode = "n";
        silent = true;
        action = "<cmd>GitBlameOpenCommitURL<cr>";
        desc = "Open Commit URL";
      }
      {
        key = "<leader>gC";
        mode = "n";
        silent = true;
        action = "<cmd>GitBlameCopySHA<cr>";
        desc = "Copy Commit SHA";
      }
    ];
  };
}
