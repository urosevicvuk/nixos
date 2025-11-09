# Motion and navigation enhancements
{ ... }:
{
  programs.nvf.settings.vim = {
    utility.motion.flash-nvim.enable = true;

    keymaps = [
      {
        key = "s";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('flash').jump()<cr>";
        desc = "Flash";
      }
    ];
  };
}
