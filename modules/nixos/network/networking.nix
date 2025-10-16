{ config, lib, ... }:
let
  inherit (config.var) hostname;
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      wifi.powersave = lib.mkIf isLaptop true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
