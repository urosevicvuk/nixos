# Hypridle is a daemon that listens for user activity and runs commands when the user is idle.
{
  pkgs,
  lib,
  ...
}:
{
  services.hypridle = {
    enable = true;
    settings = {

      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";

        # Lock session and wait for hyprlock to fully start before allowing suspend
        # This prevents the race condition where hyprlock is still loading on resume
        # Workaround for: https://github.com/systemd/systemd/issues/6978
        before_sleep_cmd = "${pkgs.bash}/bin/bash -c 'loginctl lock-session && sleep 2'";

        # Turn on display and wait for fingerprint reader to re-enumerate after resume
        # The fingerprint sensor disconnects/reconnects during suspend
        # fprintd-resume.service restarts fprintd, we wait 3 seconds for it to be ready
        # Workaround for: https://github.com/hyprwm/hyprlock/issues/577
        after_sleep_cmd = "${pkgs.bash}/bin/bash -c 'hyprctl dispatch dpms on && sleep 3'";
      };

      listener = [
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
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
