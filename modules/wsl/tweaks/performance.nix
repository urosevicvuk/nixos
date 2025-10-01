# WSL Performance Tweaks
#
# Optimizations for better WSL2 performance.

{ config, lib, ... }:
let
  cfg = config.modules.wsl.tweaks.performance;
in
{
  options.modules.wsl.tweaks.performance = {
    enable = lib.mkEnableOption "WSL performance optimizations" // {
      default = true;
      description = "Enable WSL performance tweaks";
    };
  };

  config = lib.mkIf cfg.enable {
    # Limit systemd journal size
    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';

    # Disable unnecessary services
    services.udisks2.enable = lib.mkForce false;

    # Optimize for WSL filesystem
    boot.tmp.useTmpfs = true;

    # Faster boot
    systemd.services.systemd-udev-settle.enable = false;

    # Don't wait for network on boot
    systemd.network.wait-online.enable = false;

    # Swap configuration (WSL uses Windows swap)
    swapDevices = [ ];
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };
}
