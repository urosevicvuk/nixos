# Yabai Tiling Window Manager
#
# Yabai is a tiling window manager for macOS, similar to i3/Hyprland on Linux.
# See: https://github.com/koekeishiya/yabai
#
# Note: Requires disabling System Integrity Protection (SIP) for full features

{ config, lib, ... }:
let
  cfg = config.modules.darwin.desktop.yabai;
in
{
  options.modules.darwin.desktop.yabai = {
    enable = lib.mkEnableOption "Yabai window manager";
  };

  config = lib.mkIf cfg.enable {
    services.yabai = {
      enable = true;

      config = {
        # Layout
        layout = "bsp";  # binary space partitioning

        # Window settings
        window_placement = "second_child";
        window_opacity = "off";

        # Padding and gaps
        top_padding = 8;
        bottom_padding = 8;
        left_padding = 8;
        right_padding = 8;
        window_gap = 8;

        # Mouse settings
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
      };

      extraConfig = ''
        # Additional yabai configuration
        # yabai -m rule --add app="System Settings" manage=off
      '';
    };
  };
}
