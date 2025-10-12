{ pkgs, ... }:
{
  # Hardware peripherals support
  # Gaming mice, RGB controllers, Logitech devices

  services = {
    # Gaming mice configuration via ratbagd
    ratbagd.enable = true;

    # RGB device control
    hardware.openrgb.enable = true;

    # Logitech wireless devices (keyboard, mouse, etc.)
    udev = {
      packages = [ pkgs.solaar ];
      extraRules = ''
        # Allow access to the Solaar device
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0664", GROUP="input"
        SUBSYSTEM=="hidraw", KERNELS=="*046D*", MODE="0664", GROUP="input"
      '';
    };
  };
}
