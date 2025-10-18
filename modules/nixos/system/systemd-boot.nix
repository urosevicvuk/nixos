{ pkgs, ... }: {
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    supportedFilesystems = [ "ntfs" ];
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = false;
        #consoleMode = "auto";
        #configurationLimit = 8;
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    tmp.cleanOnBoot = true;
    kernelPackages =
      pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    extraModprobeConfig = "options bluetooth disable_ertm=1 ";
  };
}
