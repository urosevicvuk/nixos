{ pkgs, config, ... }:
let
  terminal = config.var.terminal;
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      #Basic things
      "$mod, SPACE, exec, walker" # Walker Launcher
      "$shiftMod, SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      "CTRL $shiftMod, SPACE, exec, hyprlock" # Lock

      "$mod, Q, killactive," # Close window
      "$mod, T, togglefloating," # Toggle Floating
      "$mod, F, fullscreen" # Toggle Fullscreen

      "$mod, grave, exec, quickmenu" # Quickmenu

      # GUI Apps
      "$mod, B, exec, zen" # Zen Browser
      "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Thunar
      "$mod, P, exec, ${pkgs.bitwarden}/bin/bitwarden" # Bitwarden

      # CLI Apps
      "$mod, RETURN, exec, ${terminal}" # Terminal
      "$mod, G, exec, ${terminal} -e lazygit"
      "$mod, D, exec, ${terminal} -e lazydocker"
      "$mod, I, exec, ${terminal} -e btop"
      "$mod, Y, exec, ${terminal} -e yazi"

      "$mod, H, layoutmsg, focus l" # Move focus left
      "$mod, L, layoutmsg, focus r" # Move focus Right
      "$mod, K, movefocus, u" # Move focus Up
      "$mod, J, movefocus, d" # Move focus Down

      # Scrolling layout: move windows between/within columns
      "$shiftMod, H, layoutmsg, movewindowto l" # Move window to left column
      "$shiftMod, L, layoutmsg, movewindowto r" # Move window to right column
      "$shiftMod, K, movewindow, u" # Move window up
      "$shiftMod, J, movewindow, d" # Move window down

      # Move current workspace to different monitor
      "$shiftMod CTRL, h, movecurrentworkspacetomonitor, l" # Move workspace to left monitor
      "$shiftMod CTRL, l, movecurrentworkspacetomonitor, r" # Move workspace to right monitor
      "$shiftMod CTRL, k, movecurrentworkspacetomonitor, u" # Move workspace to upper monitor
      "$shiftMod CTRL, j, movecurrentworkspacetomonitor, d" # Move workspace to lower monitor

      # Screenshots
      ",PRINT, exec, screenshot-monitor" # Screenshot current monitor (save + clipboard)
      "ALT, PRINT, exec, screenshot-monitor-annotate" # Screenshot current monitor + annotate
      "$mod, PRINT, exec, screenshot-region" # Screenshot region (save + clipboard)
      "$mod ALT, PRINT, exec, screenshot-region-annotate" # Screenshot region + annotate

      # Screen Recording
      "SHIFT, PRINT, exec, record-monitor" # Record current monitor (start/stop)
      "ALT SHIFT, PRINT, exec, record-monitor-edit" # Record current monitor + open in LosslessCut
      "$mod SHIFT, PRINT, exec, record-region" # Record region (start/stop)
      "$mod ALT SHIFT, PRINT, exec, record-region-edit" # Record region + open in LosslessCut

      "$shiftMod, T, exec, hyprpanel-toggle" # Toggle hyprpanel
      #"$shiftMod, V, exec, clipboard" # Clipboard picker with wofi

      # Screen rotation
      "$mod, Prior, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,2" # Rotate 180° (PageUp)
      "$mod, Next, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,0" # Rotate back to normal (PageDown)

      # Framework function keys
      "ALT, P, exec, caffeine" # F9: Toggle caffeine
      ",XF86AudioMedia, exec, powermenu" # F12: Power menu

      #"$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi

      #Workspaces
      "$mod, 1, workspace, 1"
      "$mod SHIFT, 1, layoutmsg, movecoltoworkspace 1"
      "$mod, 2, workspace, 2"
      "$mod SHIFT, 2, layoutmsg, movecoltoworkspace 2"
      "$mod, 3, workspace, 3"
      "$mod SHIFT, 3, layoutmsg, movecoltoworkspace 3"
      "$mod, 4, workspace, 4"
      "$mod SHIFT, 4, layoutmsg, movecoltoworkspace 4"
      "$mod, 5, workspace, 5"
      "$mod SHIFT, 5, layoutmsg, movecoltoworkspace 5"
      "$mod, 6, workspace, 6"
      "$mod SHIFT, 6, layoutmsg, movecoltoworkspace 6"
      "$mod, 7, workspace, 7"
      "$mod SHIFT, 7, layoutmsg, movecoltoworkspace 7"
      "$mod, 8, workspace, 8"
      "$mod SHIFT, 8, layoutmsg, movecoltoworkspace 8"
      "$mod, 9, workspace, 9"
      "$mod SHIFT, 9, layoutmsg, movecoltoworkspace 9"
      "$mod, 0, workspace, 10"
      "$mod SHIFT, 0, layoutmsg, movecoltoworkspace 10"

      "$mod, backspace, workspace, 11"
      "$mod SHIFT, backspace, layoutmsg, movecoltoworkspace 11"

      "$mod, TAB, togglespecialworkspace"
      "$shiftMod, TAB, layoutmsg, movecoltoworkspace special"

      #"$mod, minus, workspace, name:alternative1"
      #"$mod SHIFT, minus, movetoworkspace, name:alternative1"
      #"$mod, equal, workspace, name:alternative2"
      #"$mod SHIFT, equal, movetoworkspace, name:alternative2"
    ];

    binde = [
      "$shiftMod, comma, layoutmsg, colresize -0.1" # Resize column smaller
      "$shiftMod, period, layoutmsg, colresize +0.1" # Resize column larger
    ];

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      "SHIFT,XF86AudioMute, exec, mic-toggle" # Toggle Mic Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      "SHIFT,XF86AudioRaiseVolume, exec, mic-up" # Mic Volume Up
      "SHIFT,XF86AudioLowerVolume, exec, mic-down" # Mic Volume Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
      "SHIFT,XF86MonBrightnessUp, exec, night-shift-on" # Night Shift On
      "SHIFT,XF86MonBrightnessDown, exec, night-shift-off" # Night Shift Off
    ];
  };
}
