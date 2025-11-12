{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ blueman ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    input.General.ClassicBondedOnly = false;
  };

  services.blueman.enable = true;
  hardware.xpadneo.enable = true;
}
