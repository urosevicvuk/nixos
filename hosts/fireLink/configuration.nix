{config, ...}: {
  imports = [
    # Device profile - automatically imports all server essentials
    ../profiles/server.nix

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
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
