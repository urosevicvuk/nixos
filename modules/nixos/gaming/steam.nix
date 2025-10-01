{ config, lib, pkgs, ... }:
let
  cfg = config.modules.gaming;
  deviceType = config.var.device or "desktop"; # fallback to desktop if not set
  
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
    enable = lib.mkEnableOption "gaming support" // {
      default = defaultEnabled;
      description = "Enable gaming support (auto-enabled on desktop, disabled on laptop/server)";
    };
    
    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Steam gaming platform";
      };
    };
    
    gamemode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable GameMode for performance optimization";
      };
    };
    
    gamescope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Gamescope compositor";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam.enable = lib.mkDefault cfg.steam.enable;
      gamemode.enable = lib.mkDefault cfg.gamemode.enable;
      gamescope.enable = lib.mkDefault cfg.gamescope.enable;
    };
    
    # Gaming-specific environment optimizations
    environment.variables = {
      # AMD GPU optimizations
      AMD_VULKAN_ICD = "RADV";
      # Steam integration
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${config.var.username}/.steam/root/compatibilitytools.d";
    };
  };
}