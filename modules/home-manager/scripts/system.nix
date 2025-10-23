# - ## System
#-
#- Usefull quick scripts
#-
#- - `menu` - Open walker with application launcher.
#- - `powermenu` - Open power dropdown menu.
#- - `quickmenu` - Open a dropdown menu with shortcuts and scripts.
#- - `lock` - Lock the screen. (hyprlock)
{ pkgs, ... }:

let
  menu =
    pkgs.writeShellScriptBin "menu"
      # bash
      ''
        ${pkgs.walker}/bin/walker
      '';

  powermenu =
    pkgs.writeShellScriptBin "powermenu"
      # bash
      ''
        options=(
          "󰌾 Lock"
          "󰍃 Logout"
          " Suspend"
          "󰑐 Reboot"
          "󰿅 Shutdown"
        )

        selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
        selected=''${selected:2}

        case $selected in
          "Lock")
            ${pkgs.hyprlock}/bin/hyprlock
            ;;
          "Logout")
            hyprctl dispatch exit
            ;;
          "Suspend")
            systemctl suspend
            ;;
          "Reboot")
            systemctl reboot
            ;;
          "Shutdown")
            systemctl poweroff
            ;;
        esac
      '';

  quickmenu =
    pkgs.writeShellScriptBin "quickmenu"
      # bash
      ''
        options=(
          "󰅶 Caffeine"
          "󰖔 Night-shift"
          "󰈊 Color Picker"
          "󰄀 Screenshot"
          "⏺ Screen Record"
          "📋 Clipboard"
          "🔄 Restart Panel"
          "💤 Toggle Idle"
          "🌐 WiFi Manager"
          "🔊 Audio Mixer"
          "🔋 System Monitor"
          "󰖂 Toggle VPN"
          " Nixy"
        )

        selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
        selected=''${selected:2}

        case $selected in
          "Caffeine")
            caffeine
            ;;
          "Night-shift")
            night-shift
            ;;
          "Color Picker")
            sleep 0.2 && ${pkgs.hyprpicker}/bin/hyprpicker -a
            ;;
          "Screenshot")
            screenshot region swappy
            ;;
          "Screen Record")
            record-screen
            ;;
          "Clipboard")
            clipboard
            ;;
          "Restart Panel")
            hpr
            ;;
          "Toggle Idle")
            systemctl --user is-active hypridle && systemctl --user stop hypridle || systemctl --user start hypridle
            ;;
          "WiFi Manager")
            kitty --class floating -e impala
            ;;
          "Audio Mixer")
            kitty --class floating -e wiremix
            ;;
          "System Monitor")
            kitty -e btop
            ;;
          "Toggle VPN")
            openvpn-toggle
            ;;
          "Nixy")
            kitty zsh -c nixy
            ;;
        esac
      '';

  lock =
    pkgs.writeShellScriptBin "lock"
      # bash
      ''
        ${pkgs.hyprlock}/bin/hyprlock
      '';

in
{
  home.packages = [
    menu
    powermenu
    lock
    quickmenu
  ];
}
