# - ## System
#-
#- Usefull quick scripts
#-
#- - `menu` - Open walker with application launcher.
#- - `powermenu` - Open power dropdown menu.
#- - `quickmenu` - Open a dropdown menu with shortcuts and scripts.
#- - `lock` - Lock the screen. (hyprlock)
#- - `reset-fprint` - Reset fingerprint reader after suspend (requires sudo).
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
            screenshot-region-annotate
            ;;
          "Screen Record")
            record-monitor
            ;;
        esac
      '';

  lock =
    pkgs.writeShellScriptBin "lock"
      # bash
      ''
        ${pkgs.hyprlock}/bin/hyprlock
      '';

  reset-fprint =
    pkgs.writeShellScriptBin "reset-fprint"
      # bash
      ''
        # Reset fingerprint reader by unbinding and rebinding USB controller
        # Temporary workaround for fingerprint reader disconnecting after suspend

        if [ "$EUID" -ne 0 ]; then
          echo "This script requires sudo privileges"
          echo "Usage: sudo reset-fprint"
          exit 1
        fi

        echo "Unbinding USB controller..."
        echo "0000:c1:00.4" > /sys/bus/pci/drivers/xhci_hcd/unbind

        sleep 2

        echo "Rebinding USB controller..."
        echo "0000:c1:00.4" > /sys/bus/pci/drivers/xhci_hcd/bind

        sleep 3

        echo "Restarting fprintd service..."
        systemctl restart fprintd.service

        echo "Done! Fingerprint reader should now be available."
        echo "Test with: fprintd-list ${pkgs.coreutils}/bin/whoami"
      '';

in
{
  home.packages = [
    menu
    powermenu
    lock
    quickmenu
    reset-fprint
  ];
}
