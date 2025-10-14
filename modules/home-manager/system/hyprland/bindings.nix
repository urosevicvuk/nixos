{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      #Basic things
      "$mod, SPACE, exec, menu" # Launcher
      "$shiftMod, SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      "CTRL $shiftMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock

      "$mod, Q, killactive," # Close window
      "$mod, T, togglefloating," # Toggle Floating
      "$mod, F, fullscreen" # Toggle Fullscreen

      #"$mod,X, exec, powermenu" # Powermenu
      #"$mod,C, exec, quickmenu" # Quickmenu

      # GUI Apps
      "$mod, B, exec, zen" # Zen Browser
      "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Thunar
      "$mod, P, exec, ${pkgs.bitwarden}/bin/bitwarden" # Bitwarden

      # CLI Apps
      "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty" # Kitty
      "$mod, G, exec, ${pkgs.kitty}/bin/kitty lazygit"
      "$mod, D, exec, ${pkgs.kitty}/bin/kitty lazydocker"
      "$mod, I, exec, ${pkgs.kitty}/bin/kitty btop"
      "$mod, Y, exec, ${pkgs.kitty}/bin/kitty yazi"

      "$mod, H, movefocus, l" # Move focus left
      "$mod, L, movefocus, r" # Move focus Right
      "$mod, K, movefocus, u" # Move focus Up
      "$mod, J, movefocus, d" # Move focus Down

      # Scrolling layout: move windows between/within columns
      "$shiftMod, H, layoutmsg, movewindowto l" # Move window to left column
      "$shiftMod, L, layoutmsg, movewindowto r" # Move window to right column
      "$shiftMod, K, layoutmsg, movewindowto u" # Move window up within column
      "$shiftMod, J, layoutmsg, movewindowto d" # Move window down within column

      "$shiftMod, up, focusmonitor, -1" # Focus previous monitor
      "$shiftMod, down, focusmonitor, 1" # Focus next monitor

      # Scrolling layout: navigate between columns
      "$mod, bracketleft, layoutmsg, move -col" # Scroll layout left (previous column)
      "$mod, bracketright, layoutmsg, move +col" # Scroll layout right (next column)

      # Move current workspace to different monitor
      "$shiftMod CTRL, left, movecurrentworkspacetomonitor, l" # Move workspace to left monitor
      "$shiftMod CTRL, right, movecurrentworkspacetomonitor, r" # Move workspace to right monitor
      "$shiftMod CTRL, up, movecurrentworkspacetomonitor, u" # Move workspace to upper monitor
      "$shiftMod CTRL, down, movecurrentworkspacetomonitor, d" # Move workspace to lower monitor

      "$shiftMod, S, exec, hyprshot -m region -o ~/Pictures/screenshots/" # Screenshot region
      ",PRINT, exec, hyprshot -m output -o ~/Pictures/screenshots/" # Screenshot monitor

      "$shiftMod, T, exec, hyprpanel-toggle" # Toggle hyprpanel
      "$shiftMod CTRL, T, exec, hpr" # Toggle hyprpanel
      "$shiftMod, V, exec, clipboard" # Clipboard picker with wofi

      "$mod, F1, exec, hyprctl switchxkblayout logitech-pro-gaming-keyboard 0" # US
      "$mod, F2, exec, hyprctl switchxkblayout logitech-pro-gaming-keyboard 1" # RS ćirilica
      "$mod, F3, exec, hyprctl switchxkblayout logitech-pro-gaming-keyboard 2" # RS latinica
      "$mod, F4, exec, night-shift" # Toggle night shift

      "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi

      #Workspaces
      "$mod, 1, workspace, 1"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod, 2, workspace, 2"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod, 3, workspace, 3"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod, 4, workspace, 4"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod, 5, workspace, 5"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod, 6, workspace, 6"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod, 7, workspace, 7"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod, 8, workspace, 8"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod, 9, workspace, 9"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod, 0, workspace, 10"
      "$mod SHIFT, 0, movetoworkspace, 10"

      #"$mod, minus, workspace, name:alternative1"
      #"$mod SHIFT, minus, movetoworkspace, name:alternative1"
      #"$mod, equal, workspace, name:alternative2"
      #"$mod SHIFT, equal, movetoworkspace, name:alternative2"
    ];

    binde = [
      "$shiftMod CTRL, minus, layoutmsg, colresize -0.1" # Resize column smaller
      "$shiftMod CTRL, equal, layoutmsg, colresize +0.1" # Resize column larger
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
