{ config, ... }:
{
  imports = [
    ../../modules/nixos/audio.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/systemd-boot.nix
    #../../modules/nixos/sddm.nix
    ../../modules/nixos/tuigreet.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/utils.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/virtualization.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
