{ config, ... }:
let
  inherit (config.var) hostname;
in
{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
