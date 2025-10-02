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
    ../../modules/nixos/desktop/sddm.nix

    # Development tools
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/development/virtualization.nix
    ../../modules/nixos/development/tools.nix

    # Gaming - auto-enabled on desktop
    ../../modules/nixos/gaming/steam.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
