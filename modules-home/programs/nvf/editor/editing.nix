# Editing enhancements - commenting and auto-pairs
{ ... }:
{
  programs.nvf.settings.vim = {
    # Using mini.nvim for commenting and auto-pairs
    # Removed comment-nvim as it's redundant with mini.comment
    startPlugins = [
      # Mini plugins are loaded via mini.nix in ui/
    ];
  };
}
