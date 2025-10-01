# Homebrew Package Management
#
# Homebrew is used on macOS for apps that aren't available in nixpkgs
# or that work better as native Mac apps.
#
# Usage: Import and add packages via homebrew.brews and homebrew.casks

{ config, lib, ... }:
let
  cfg = config.modules.darwin.system.homebrew;
in
{
  options.modules.darwin.system.homebrew = {
    enable = lib.mkEnableOption "Homebrew package manager" // {
      default = true;
      description = "Enable Homebrew for macOS applications";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      # Command-line tools via Homebrew
      brews = [
        # Add Homebrew formulae here
        # Example: "ffmpeg"
      ];

      # macOS applications via Homebrew Cask
      casks = [
        # Add GUI applications here
        # Examples:
        # "firefox"
        # "visual-studio-code"
        # "docker"
        # "discord"
      ];

      # Mac App Store apps
      masApps = {
        # Add Mac App Store apps here (requires mas-cli)
        # Example: "Xcode" = 497799835;
      };
    };
  };
}
