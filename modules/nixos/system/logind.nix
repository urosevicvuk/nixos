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
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };
}
