{ config, lib, ... }:
let
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  # Laptop-specific logind configuration
  # Handles lid close behavior and power button actions
  services.logind = lib.mkIf isLaptop {
    settings = {
      #Login = {
      #  HandleLidSwitch = "suspend";
      #  HandleLidSwitchExternalPower = "suspend";
      #  HandleLidSwitchDocked = "ignore";
      #  # Ensure session locks before suspend (systemd sleep hook)
      #  # This works with hypridle's before_sleep_cmd to lock before suspend
      #  # Gives hypridle up to 5 seconds to complete before_sleep_cmd
      #  # InhibitDelayMaxSec = 5;
      #};
    };
  };
}
