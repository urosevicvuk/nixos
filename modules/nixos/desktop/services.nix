{ pkgs, config, lib, ... }:
let
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  # Desktop-related system services
  services = {
    # D-Bus message bus
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };

    # Virtual filesystem support (USB drives, etc.)
    gvfs.enable = true;

    # Battery/power management
    upower.enable = true;
    power-profiles-daemon.enable = true;

    # Disk management
    udisks2.enable = true;

    # Input device configuration (touchpad, etc.)
    libinput.enable = true;

    # GNOME keyring for password storage
    gnome.gnome-keyring.enable = true;

    # Profile Sync Daemon - moves browser profiles to tmpfs
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };

  programs = {
    dconf.enable = true;
  };

  # Enable graphics support
  hardware.graphics.enable = true;

  # Laptop-specific power management
  powerManagement = lib.mkIf isLaptop {
    enable = true;
    powertop.enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };
}
