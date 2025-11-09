# Dashboard and start screen
{ ... }:
{
  programs.nvf.settings.vim = {
    # Using alpha as main dashboard
    dashboard.alpha.enable = true;

    # mini.starter available as alternative (from mini.nix)
  };
}
