# Notifications and messages
{ ... }:
{
  programs.nvf.settings.vim = {
    ui.noice.enable = true;

    # mini.notify is loaded via mini.nix
    # fidget-nvim for LSP progress is in visuals.nix
  };
}
