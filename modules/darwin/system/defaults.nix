# macOS System Defaults Configuration
#
# This module configures macOS system preferences via nix-darwin.
# See: https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
# Usage: Import in darwin configuration and customize as needed

{ config, lib, pkgs, ... }:
let
  cfg = config.modules.darwin.system.defaults;
in
{
  options.modules.darwin.system.defaults = {
    enable = lib.mkEnableOption "macOS system defaults" // {
      default = true;
      description = "Configure macOS system defaults";
    };
  };

  config = lib.mkIf cfg.enable {
    # Dock settings
    system.defaults.dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
    };

    # Finder settings
    system.defaults.finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    # NSGlobalDomain settings (macOS-wide)
    system.defaults.NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    # Trackpad settings
    system.defaults.trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = false;
    };
  };
}
