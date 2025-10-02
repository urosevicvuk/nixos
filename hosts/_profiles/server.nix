{ ... }:
{
  imports = [
    # Core modules - always enabled
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/systemd-boot.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/utils.nix
    ../../modules/nixos/core/home-manager.nix

    # Server essentials
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/network/tailscale.nix
    ../../modules/nixos/server/ssh.nix
    ../../modules/nixos/server/firewall.nix

    # Server services (commented - enable as needed in host config)
    # ../../modules/nixos/server/web/nginx.nix
    # ../../modules/nixos/server/media/arr.nix
    # ../../modules/nixos/server/services/bitwarden.nix
    # ../../modules/nixos/server/services/adguardhome.nix
  ];
}
