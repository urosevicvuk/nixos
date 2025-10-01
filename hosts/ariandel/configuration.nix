{ config, ... }:
{
  imports = [
    # Device profile - automatically imports all laptop modules
    ../profiles/laptop.nix

    # Host-specific configuration
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
