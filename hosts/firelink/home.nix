{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Programs
    ../../modules/home-manager/programs/nvf
    ../../modules/home-manager/programs/shell
    ../../modules/home-manager/programs/fetch
    ../../modules/home-manager/programs/git.nix
    ../../modules/home-manager/programs/ghostty.nix
    ../../modules/home-manager/programs/kitty.nix

    # Scripts
    ../../modules/home-manager/scripts # All scripts

    ./variables.nix
    ./secrets
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
      duckdb

      # Utils
      nh
      zip
      unzip
      optipng
      pfetch
      btop
      fastfetch
      tailscale

      claude-code

    ];

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
