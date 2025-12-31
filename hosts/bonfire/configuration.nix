{ config, ... }:
{
  imports = [
    # Core system modules
    ../../modules-nixos/system/nix.nix
    ../../modules-nixos/system/systemd.nix
    ../../modules-nixos/system/users.nix
    ../../modules-nixos/system/utils.nix
    ../../modules-nixos/system/home-manager.nix
    ../../modules-nixos/system/locale.nix
    ../../modules-nixos/system/environment.nix
    ../../modules-nixos/system/security.nix

    # Network modules
    ../../modules-nixos/network/networking.nix
    ../../modules-nixos/network/tailscale.nix
    ../../modules-nixos/network/firewall.nix

    # Server modules
    ../../modules-nixos/server/ssh.nix

    # Cluster modules (TODO: will be created in future phases)
    # ../../modules-nixos/cluster/k3s.nix
    # ../../modules-nixos/cluster/storage.nix
    # ../../modules-nixos/cluster/monitoring.nix

    # Host-specific configuration
    ./variables.nix
    # ./hardware-configuration.nix  # Will be generated during installation
    # ./disko.nix                    # Optional: ZFS configuration
  ];

  # Home manager configuration
  home-manager.users."${config.var.username}" = import ./home.nix;

  # NixOS state version
  system.stateVersion = "24.05";
}
