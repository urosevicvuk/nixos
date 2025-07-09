{ lib, ... }:
{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    syntaxHighlighting = true;

    options = {
      autoindent = true;
      smartindent = true;
      shiftwidth = 2;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      mousemoveevent = true;
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      tabstop = 2;
      softtabstop = 2;
      wrap = false;
      scrolloff = 8;
    };

    navigation.harpoon = {
      enable = true;
      mappings = {
        markFile = "<leader>\`";
        listMarks = "<leader>~";
        file1 = "<leader>1";
        file2 = "<leader>2";
        file3 = "<leader>3";
        file4 = "<leader>4";
      };
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

    session = {
      nvim-session-manager.enable = true;
    };

    theme = {
      enable = true;
      #name = lib.mkForce "gruvbox";
      #style = lib.mkForce "dark";
      transparent = lib.mkForce true;
    };

  };
}
