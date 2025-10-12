{ config, ... }:
{
  imports = [
    # Core modules
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/systemd-boot.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/utils.nix
    ../../modules/nixos/core/home-manager.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/locale.nix
    ../../modules/nixos/core/environment.nix
    ../../modules/nixos/core/security.nix

    # Desktop environment
    # ../../modules/nixos/desktop/audio.nix
    # ../../modules/nixos/desktop/bluetooth.nix
    # ../../modules/nixos/desktop/docker.nix
    # ../../modules/nixos/desktop/fonts.nix
    # ../../modules/nixos/desktop/hyprland.nix
    # ../../modules/nixos/desktop/sddm.nix
    # ../../modules/nixos/desktop/tuigreet.nix

    # Development tools
    ../../modules/nixos/development/docker.nix
    # ../../modules/nixos/development/virtualization.nix
    # ../../modules/nixos/development/tools.nix

    # Gaming
    # ../../modules/nixos/gaming/steam.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
    ../../modules/nixos/network/cloudflared.nix

    # Server
    ../../modules/nixos/server/ssh.nix
    ../../modules/nixos/server/firewall.nix
    # ../../modules/nixos/server/media/arr.nix
    ../../modules/nixos/server/services/nextcloud.nix
    # ../../modules/nixos/server/services/adguardhome.nix
    # ../../modules/nixos/server/services/bitwarden.nix
    # ../../modules/nixos/server/services/glance.nix
    # ../../modules/nixos/server/services/headscale.nix
    # ../../modules/nixos/server/services/hoarder.nix
    # ../../modules/nixos/server/services/mealie.nix
    # ../../modules/nixos/server/services/meilisearch.nix
    # ../../modules/nixos/server/services/search-nixos-api.nix
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
