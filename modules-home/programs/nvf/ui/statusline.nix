# Statusline configuration
{ lib, ... }:
{
  programs.nvf.settings.vim.statusline.lualine = {
    enable = true;
    theme = lib.mkForce "gruvbox_dark";
  };
}
