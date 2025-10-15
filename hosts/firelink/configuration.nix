{ config, ... }:
{
  imports = [
    # System modules
    ../../modules/nixos/system/nix.nix
    ../../modules/nixos/system/systemd-boot.nix
    ../../modules/nixos/system/users.nix
    ../../modules/nixos/system/utils.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/environment.nix
    ../../modules/nixos/system/security.nix

    # Services
    ../../modules/nixos/services/docker.nix

    # Network
    ../../modules/nixos/network/networking.nix
    ../../modules/nixos/network/tailscale.nix
    ../../modules/nixos/network/firewall.nix

    # Server
    ../../modules/nixos/server/ssh.nix
    ../../modules/nixos/server/services/cloudflared.nix
    ../../modules/nixos/server/services/nextcloud.nix
    ../../modules/nixos/server/services/minecraft.nix
    ../../modules/nixos/server/services/minecraft-forge.nix
    ../../modules/nixos/server/services/playit.nix
    # ../../modules/nixos/server/services/adguardhome.nix
    # ../../modules/nixos/server/services/bitwarden.nix
    # ../../modules/nixos/server/services/glance.nix
    # ../../modules/nixos/server/services/headscale.nix
    # ../../modules/nixos/server/services/hoarder.nix
    # ../../modules/nixos/server/services/mealie.nix
    # ../../modules/nixos/server/services/meilisearch.nix
    # ../../modules/nixos/server/services/search-nixos-api.nix
    # ../../modules/nixos/server/media/arr.nix
    ../../modules/nixos/server/web/nginx.nix

    # Host-specific configuration
    ./hardware-configuration.nix
    ./variables.nix
    ./secrets
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
