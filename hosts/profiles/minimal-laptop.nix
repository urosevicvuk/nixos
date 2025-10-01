{ ... }:
{
  imports = [
    # Core modules - always enabled
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/systemd-boot.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/utils.nix
    ../../modules/nixos/core/home-manager.nix

    # Minimal desktop environment - optimized for older hardware
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/tuigreet.nix

    # Minimal development tools - no heavy virtualization
    ../../modules/nixos/development/docker.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
