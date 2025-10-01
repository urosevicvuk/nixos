# WSL Core Configuration
#
# Basic WSL2 setup using nixos-wsl module.
# See: https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
let
  cfg = config.modules.wsl.core;
in
{
  options.modules.wsl.core = {
    enable = lib.mkEnableOption "WSL core configuration" // {
      default = true;
      description = "Enable WSL-specific settings";
    };

    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = config.var.username or "vyke";
      description = "Default WSL user";
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = cfg.defaultUser;

      # Start systemd on boot
      startMenuLaunchers = true;

      # Enable native Docker or use Docker Desktop
      # docker-native.enable = true;

      # WSL-specific settings
      wslConf = {
        automount.root = "/mnt";
        network.generateHosts = true;
        network.generateResolvConf = true;
      };
    };

    # Optimize for WSL performance
    boot.tmp.cleanOnBoot = true;

    # WSL doesn't need these
    systemd.services.systemd-udevd.enable = lib.mkForce false;
    systemd.services.systemd-udev-trigger.enable = lib.mkForce false;
  };
}
