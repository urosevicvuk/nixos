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
          "󰒲 Hibernate"
          "󰑐 Reboot"
          "󰚥 Reboot to UEFI"
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
          "Hibernate")
            systemctl hibernate
            ;;
          "Reboot")
            systemctl reboot
            ;;
          "Reboot to UEFI")
            systemctl reboot --firmware-setup
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
            smart-screenshot
            ;;
          "Screen Record")
            record-screen
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
