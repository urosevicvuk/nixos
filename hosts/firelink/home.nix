{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Programs
    ../../modules-home/programs/nvf
    ../../modules-home/programs/shell
    ../../modules-home/programs/fetch
    ../../modules-home/programs/git.nix
    ../../modules-home/programs/ghostty.nix
    ../../modules-home/programs/kitty.nix

    # Scripts
    ../../modules-home/scripts # All scripts

    # Secrets
    ../../secrets/shared

    ./variables.nix
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
