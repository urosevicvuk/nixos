# Theme configuration
{ lib, ... }:
{
  programs.nvf.settings.vim.theme = {
    enable = true;
    name = lib.mkForce "gruvbox";
    style = lib.mkForce "dark";
    transparent = lib.mkForce true;
  };
}
