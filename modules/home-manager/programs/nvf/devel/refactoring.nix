# Refactoring tools
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      refactoring-nvim
    ];

    luaConfigRC.refactoring = ''
      require('refactoring').setup({})
    '';

    keymaps = [
      {
        key = "<leader>re";
        mode = [ "x" "n" ];
        silent = true;
        action = "<cmd>lua require('refactoring').refactor('Extract Function')<CR>";
        desc = "Extract Function";
      }
      {
        key = "<leader>rf";
        mode = [ "x" "n" ];
        silent = true;
        action = "<cmd>lua require('refactoring').refactor('Extract Function To File')<CR>";
        desc = "Extract Function To File";
      }
      {
        key = "<leader>rv";
        mode = [ "x" "n" ];
        silent = true;
        action = "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>";
        desc = "Extract Variable";
      }
      {
        key = "<leader>ri";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>";
        desc = "Inline Variable";
      }
    ];
  };
}
