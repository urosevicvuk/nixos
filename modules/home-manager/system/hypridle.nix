# Hypridle is a daemon that listens for user activity and runs commands when the user is idle.
{ pkgs, lib, config, ... }:
let
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  services.hypridle = {
    enable = true;
    settings = {

      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        # Wait for hyprlock to fully lock before suspending (option 3)
        # This prevents the screen flash issue
        wait_cmd = 3;
      };

      listener = if isLaptop then [
        # Laptop: aggressive power saving
        # Dim screen after 4 minutes
        {
          timeout = 240;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        # Turn off screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Lock screen after 10 minutes
        {
          timeout = 600;
          on-timeout = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }

        # Suspend after 11 minutes
        {
          timeout = 660;
          on-timeout = "systemctl suspend";
        }
      ] else [
        # Desktop: never idle, never sleep
        # Only lock on manual trigger or before sleep
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
