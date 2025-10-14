{ pkgs, config, ... }:
{
  # Gaming programs and utilities
  programs = {
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
  };

  # Home-manager gaming packages
  home-manager.users.${config.var.username}.home.packages = with pkgs; [
    lutris
    prismlauncher
    (wineWowPackages.stable.override { waylandSupport = true; })
    winetricks
    protonup
    protontricks
    shadps4
  ];
}
