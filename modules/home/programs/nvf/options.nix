{ lib, ... }:
{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    # syntaxHighlighting = true;
    options = {
      autoindent = true;
      smartindent = true;
      shiftwidth = 4;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      mousemoveevent = true;
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      tabstop = 4;
      softtabstop = 4;
      wrap = false;
    };
    globals = {
      navic_silence = true; # navic tries to attach multiple LSPs and fails
      suda_smart_edit = 1; # use super user write automatically
      neovide_scale_factor = 0.7;
      neovide_cursor_animation_length = 0.1;
      neovide_cursor_short_animation_length = 0;
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    projects = {
      project-nvim.enable = true;
    };
    dashboard = {
      alpha.enable = true;
    };
    theme = {
      enable = true;
      #name = lib.mkForce "gruvbox";
      #style = lib.mkForce "dark";
      transparent = lib.mkForce true;
    };
  };
}
