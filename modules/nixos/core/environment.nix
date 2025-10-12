{ pkgs, config, ... }:
let
  inherit (config.var) username;
  inherit (config.var) configDirectory;
in
{
  # Environment variables
  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    NH_FLAKE = configDirectory;
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    TERM = "kitty";
    BROWSER = "zen-beta";
    PULSE_LATENCY_MSEC = 60;
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    fd
    bc
    gcc
    git-ignore
    xdg-utils
    wget
    curl
    vim
    nixfmt-rfc-style
  ];

  # Enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  # Faster rebuilding - disable unnecessary documentation
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };
}
