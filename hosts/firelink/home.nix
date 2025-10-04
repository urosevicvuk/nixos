{ pkgs, config, ... }:
{

  imports = [
    # Mostly user-specific configuration
    ./variables.nix

    # Programs
    ../../modules/home-manager/programs/nvf
    ../../modules/home-manager/programs/shell
    ../../modules/home-manager/programs/fetch
    ../../modules/home-manager/programs/git

    # Scripts
    ../../home/scripts # All scripts
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Dev
      go
      nodejs
      python3
      jq
      just
      pnpm
      wireguard-tools

      # Utils
      zip
      unzip
      optipng
      pfetch
      btop
      fastfetch
      tailscale
    ];

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
