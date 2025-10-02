{ ... }:
{
  imports = [
    # Core modules - always enabled
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/systemd-boot.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/utils.nix
    ../../modules/nixos/core/home-manager.nix

    # Desktop environment
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/tuigreet.nix

    # Development tools
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/development/tools.nix

    # Gaming - disabled by default on laptop, can be enabled in host config
    ../../modules/nixos/gaming/steam.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
