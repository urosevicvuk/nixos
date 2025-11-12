# Git integration - Using Snacks.nvim (Folke's preference)
{ ... }:
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
  };
}
