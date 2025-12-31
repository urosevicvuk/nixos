{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    # Essential programs
    ../../modules-home/programs/shell
    ../../modules-home/programs/git.nix
    ../../modules-home/programs/nvf

    # Secrets
    ../../secrets/shared

    # Host variables
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Minimal server packages
    packages = with pkgs; [
      # System utilities
      htop
      btop
      curl
      wget
      rsync

      # Container tools
      docker-compose
      kubectl
      kubernetes-helm
      k9s

      # Monitoring
      prometheus
      grafana
    ];

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
