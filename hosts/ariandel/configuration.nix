{ config, ... }:
{
  imports = [
    # System modules
    ../../modules-nixos/system/nix.nix
    ../../modules-nixos/system/systemd-boot.nix
    ../../modules-nixos/system/users.nix
    ../../modules-nixos/system/utils.nix
    ../../modules-nixos/system/home-manager.nix
    ../../modules-nixos/system/locale.nix
    ../../modules-nixos/system/environment.nix
    ../../modules-nixos/system/security.nix
    ../../modules-nixos/system/logind.nix

    # Hardware
    ../../modules-nixos/hardware/audio.nix
    ../../modules-nixos/hardware/bluetooth.nix
    ../../modules-nixos/hardware/keyd.nix
    ../../modules-nixos/hardware/printing.nix
    # ../../modules-nixos/hardware/peripherals.nix

    # Desktop environment
    ../../modules-nixos/desktop/fonts.nix
    ../../modules-nixos/desktop/hyprland.nix
    ../../modules-nixos/desktop/services.nix
    ../../modules-nixos/desktop/xdg.nix
    # ../../modules-nixos/desktop/sddm.nix
    ../../modules-nixos/desktop/tuigreet.nix

    # Programs
    # ../../modules-nixos/programs/gaming.nix
    ../../modules-nixos/programs/filesharing.nix
    # ../../modules-nixos/programs/virtualization.nix

    # Services
    ../../modules-nixos/services/docker.nix

    # Network
    ../../modules-nixos/network/networking.nix
    ../../modules-nixos/network/tailscale.nix
    ../../modules-nixos/network/firewall.nix

    # Host-specific configuration
    ./variables.nix
    ./hardware-configuration.nix
  ];

  # Hibernate support
  boot.resumeDevice = "/dev/disk/by-uuid/1fe041f7-c293-442b-ac57-faf8933c3913";

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
