{ config, lib, pkgs, ... }:
let
  cfg = config.modules.gaming;
  deviceType = config.var.device or "desktop";
  
  # Smart defaults based on device type
  defaultEnabled = {
    desktop = true;
    laptop = false;
    server = false;
    minimal-laptop = false;
  }.${deviceType} or false;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "gaming packages and configurations" // {
      default = defaultEnabled;
      description = "Enable gaming packages (auto-enabled on desktop, disabled on laptop/server)";
    };
    
    launchers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Install game launchers (Lutris, PrismLauncher)";
      };
    };
    
    wine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Install Wine and related tools";
      };
    };
    
    emulation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Install emulators (shadps4, etc.)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Game launchers
    ] ++ lib.optionals cfg.launchers.enable [
      lutris
      prismlauncher
    ] ++ lib.optionals cfg.wine.enable [
      (wineWowPackages.stable.override { waylandSupport = true; })
      winetricks
      protonup
      protontricks
    ] ++ lib.optionals cfg.emulation.enable [
      shadps4
    ];
    
    # Gaming-specific configurations
    wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
      # Auto-start Steam on workspace 5
      exec-once = [
        "[workspace 5 silent] steam"
      ];
      
      # Gaming-specific window rules
      windowrulev2 = [
        "workspace 5, class:^(steam)$"
        "workspace 5, class:^(lutris)$"
        "fullscreen, class:^(gamescope)$"
      ];
    };
  };
}