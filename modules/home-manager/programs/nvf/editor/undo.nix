# Undo history visualization
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      undotree
    ];

    keymaps = [
      {
        key = "<leader>u";
        mode = "n";
        silent = true;
        action = "<cmd>UndotreeToggle<CR>";
        desc = "Toggle Undotree";
      }
    ];
  };
}
