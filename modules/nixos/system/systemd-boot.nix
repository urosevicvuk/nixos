{ pkgs, config, lib, ... }:
let
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
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

    # Silent boot + laptop-specific kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ] ++ lib.optionals isLaptop [
      # Framework AMD laptop optimizations
      "mem_sleep_default=s2idle"      # Better suspend/sleep support
      "amdgpu.dcdebugmask=0x10"       # AMD GPU power optimization
      "rtc_cmos.use_acpi_alarm=1"     # RTC alarm support for wake
      "amd_pstate=active"              # AMD P-State EPP for power/performance
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    extraModprobeConfig = "options bluetooth disable_ertm=1 ";
  };
}
