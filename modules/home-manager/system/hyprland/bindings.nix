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
      "$mod, K, layoutmsg, focus u" # Move focus Up
      "$mod, J, layoutmsg, focus d" # Move focus Down

      # Scrolling layout: move windows between/within columns
      "$shiftMod, H, layoutmsg, movewindowto l" # Move window to left column
      "$shiftMod, L, layoutmsg, movewindowto r" # Move window to right column
      "$shiftMod, K, layoutmsg, movewindowto u" # Move window up within column
      "$shiftMod, J, layoutmsg, movewindowto d" # Move window down within column

      # Move current workspace to different monitor
      "$shiftMod CTRL, h, movecurrentworkspacetomonitor, l" # Move workspace to left monitor
      "$shiftMod CTRL, l, movecurrentworkspacetomonitor, r" # Move workspace to right monitor
      "$shiftMod CTRL, k, movecurrentworkspacetomonitor, u" # Move workspace to upper monitor
      "$shiftMod CTRL, j, movecurrentworkspacetomonitor, d" # Move workspace to lower monitor

      "$shiftMod, s, exec, hyprshot -m region -o ~/Pictures/screenshots/ -z" # Screenshot region
      "$mod, PRINT, exec, hyprshot -m region -o ~/Pictures/screenshots/ -z" # Screenshot region
      ",PRINT, exec, hyprshot -m output -m $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') -o ~/Pictures/screenshots/" # Screenshot current monitor instantly

      "$shiftMod, T, exec, hyprpanel-toggle" # Toggle hyprpanel
      #"$shiftMod, V, exec, clipboard" # Clipboard picker with wofi

      "$mod, F4, exec, night-shift" # Toggle night shift

      # Screen rotation
      "$mod, Prior, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,2" # Rotate 180° (PageUp)
      "$mod, Next, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,0" # Rotate back to normal (PageDown)

      # Framework function keys
      "ALT, P, exec, record-screen" # F9: Toggle screen recording
      ",XF86AudioMedia, exec, quickmenu" # F12: Quick scripts menu

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
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];
  };
}
