{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      epson-escpr
      epson-escpr2
    ];
    startWhenNeeded = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  programs.system-config-printer.enable = true;
}
