# Snacks.nvim - Folke's utility plugin suite
{ ... }:
{
  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      image = {
        enabled = true;
      };
      quickfile = {
        enabled = true;
      };
      statuscolumn = {
        enabled = true;
      };
      zen = {
        enabled = true;
      };
      bufdelete = {
        enabled = true;
      };
      input = {
        enabled = true;
      };
      # picker and gitsigns are configured in their respective feature files
    };
  };
}
