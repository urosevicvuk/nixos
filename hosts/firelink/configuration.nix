<<<<<<< HEAD
{config, ...}: {
  imports = [
    # Device profile - automatically imports all server essentials
    ../_profiles/server.nix

    # Host-specific configuration
    ./hardware-configuration.nix
    ./variables.nix
    ./secrets


    # Optional server services - enable as needed:
    # ../../modules/nixos/server/web/nginx.nix
    # ../../modules/nixos/server/services/bitwarden.nix
    # ../../modules/nixos/server/services/glance.nix
    # ../../modules/nixos/server/services/adguardhome.nix
    # ../../modules/nixos/server/services/mealie.nix
    # ../../modules/nixos/server/media/arr.nix
=======
{ config, ... }:
{
  imports = [
    ../../modules/nixos/personal/home-manager.nix
    ../../modules/nixos/personal/nix.nix
    ../../modules/nixos/personal/systemd-boot.nix
    ../../modules/nixos/personal/users.nix
    ../../modules/nixos/personal/utils.nix
    ../../modules/nixos/personal/docker.nix
    ../../modules/nixos/personal/tailscale.nix

    ../../modules/nixos/server/ssh.nix
    #../../modules/nixos/server/bitwarden.nix
    #../../modules/nixos/server/firewall.nix
    #../../modules/nixos/server/nginx.nix
    #../../modules/nixos/server/nextcloud.nix
    #../../modules/nixos/server/glance.nix
    #../../modules/nixos/server/adguardhome.nix
    #../../modules/nixos/server/hoarder.nix
    #../../modules/nixos/server/arr.nix
    #../../modules/nixos/server/mealie.nix
    #../../modules/nixos/server/meilisearch.nix
    #../../modules/nixos/server/search-nixos-api.nix
    #../../modules/nixos/server/headscale.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix

    ./secrets
>>>>>>> 2bdfd6c
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
