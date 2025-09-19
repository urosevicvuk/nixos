{ config, lib, pkgs, ... }:
let
  cfg = config.modules.development;
  deviceType = config.var.device or "desktop";
  
  # Smart defaults - dev tools useful on desktop/laptop, not server
  defaultEnabled = {
    desktop = true;
    laptop = true;
    server = false;
    minimal-laptop = false; # Minimal laptop might not want heavy IDEs
  }.${deviceType} or false;
in
{
  options.modules.development = {
    enable = lib.mkEnableOption "development tools and environments" // {
      default = defaultEnabled;
      description = "Enable development tools (auto-enabled on desktop/laptop)";
    };
    
    containers = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && (deviceType == "desktop");
        description = "Enable container tools (Docker, Podman)";
      };
    };
    
    languages = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable language-specific tools and runtimes";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Container support
    virtualisation = lib.mkIf cfg.containers.enable {
      docker.enable = true;
      podman.enable = true;
    };
    
    # Development-friendly services
    services = {
      # Enable development databases
      postgresql = lib.mkIf (deviceType == "desktop") {
        enable = true;
        package = pkgs.postgresql_15;
      };
    };
    
    # Development environment variables
    environment.variables = lib.mkIf cfg.languages.enable {
      EDITOR = "nvim";
      BROWSER = "zen-beta";
    };
  };
}