{ config, ... }:
{
  imports = [
    ../../modules/nixos/personal/audio.nix
    ../../modules/nixos/personal/bluetooth.nix
    ../../modules/nixos/personal/docker.nix
    ../../modules/nixos/personal/fonts.nix
    ../../modules/nixos/personal/home-manager.nix
    ../../modules/nixos/personal/nix.nix
    ../../modules/nixos/personal/systemd-boot.nix
    ../../modules/nixos/personal/tuigreet.nix
    ../../modules/nixos/personal/users.nix
    ../../modules/nixos/personal/utils.nix
    ../../modules/nixos/personal/tailscale.nix
    ../../modules/nixos/personal/hyprland.nix
    #../../modules/nixos/personal/virtualization.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
