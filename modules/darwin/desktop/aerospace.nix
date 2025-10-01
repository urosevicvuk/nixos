# AeroSpace Tiling Window Manager
#
# AeroSpace is a modern tiling window manager for macOS.
# Alternative to Yabai, doesn't require disabling SIP.
# See: https://github.com/nikitabobko/AeroSpace

{ config, lib, ... }:
let
  cfg = config.modules.darwin.desktop.aerospace;
in
{
  options.modules.darwin.desktop.aerospace = {
    enable = lib.mkEnableOption "AeroSpace window manager";
  };

  config = lib.mkIf cfg.enable {
    # AeroSpace is installed via Homebrew cask
    homebrew.casks = [ "aerospace" ];

    # Configuration file would go in home-manager:
    # home.file.".aerospace.toml".text = ''
    #   # AeroSpace configuration
    # '';
  };
}
