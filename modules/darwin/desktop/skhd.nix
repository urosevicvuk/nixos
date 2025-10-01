# skhd Hotkey Daemon
#
# skhd provides keyboard shortcuts for macOS, often used with Yabai.
# See: https://github.com/koekeishiya/skhd

{ config, lib, ... }:
let
  cfg = config.modules.darwin.desktop.skhd;
in
{
  options.modules.darwin.desktop.skhd = {
    enable = lib.mkEnableOption "skhd hotkey daemon";
  };

  config = lib.mkIf cfg.enable {
    services.skhd = {
      enable = true;

      skhdConfig = ''
        # Window focus
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # Move windows
        shift + alt - h : yabai -m window --swap west
        shift + alt - j : yabai -m window --swap south
        shift + alt - k : yabai -m window --swap north
        shift + alt - l : yabai -m window --swap east

        # Resize windows
        ctrl + alt - h : yabai -m window --resize left:-20:0
        ctrl + alt - j : yabai -m window --resize bottom:0:20
        ctrl + alt - k : yabai -m window --resize top:0:-20
        ctrl + alt - l : yabai -m window --resize right:20:0

        # Float/unfloat window
        shift + alt - space : yabai -m window --toggle float

        # Fullscreen
        alt - f : yabai -m window --toggle zoom-fullscreen

        # Terminal
        alt - return : open -a kitty

        # Browser
        alt - b : open -a Firefox
      '';
    };
  };
}
