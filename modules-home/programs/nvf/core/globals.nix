# Global variables
{ ... }:
{
  programs.nvf.settings.vim.globals = {
    mapleader = " ";
    navic_silence = true; # navic tries to attach multiple LSPs and fails
    suda_smart_edit = 1; # use super user write automatically
    neovide_scale_factor = 0.7;
    neovide_cursor_animation_length = 0.1;
    neovide_cursor_short_animation_length = 0;
  };
}
