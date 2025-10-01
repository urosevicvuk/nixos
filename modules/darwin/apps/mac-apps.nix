# Common macOS Applications
#
# This module provides common GUI applications for macOS via Homebrew.
# Customize per host as needed.

{ config, lib, ... }:
let
  cfg = config.modules.darwin.apps;
in
{
  options.modules.darwin.apps = {
    enable = lib.mkEnableOption "Common macOS applications" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = [
      # Browsers
      # "firefox"
      # "google-chrome"

      # Development
      # "visual-studio-code"
      # "docker"
      # "iterm2"

      # Communication
      # "discord"
      # "slack"
      # "zoom"

      # Utilities
      # "alfred"
      # "rectangle"  # Window management
      # "stats"      # System monitor

      # Media
      # "vlc"
      # "spotify"
    ];
  };
}
