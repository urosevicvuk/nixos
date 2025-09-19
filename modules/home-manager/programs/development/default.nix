{ config, lib, pkgs, ... }:
let
  cfg = config.modules.development;
  deviceType = config.var.device or "desktop";
  
  # Smart defaults
  defaultEnabled = {
    desktop = true;
    laptop = true;
    server = false;
    minimal-laptop = false;
  }.${deviceType} or false;
in
{
  options.modules.development = {
    enable = lib.mkEnableOption "development packages and tools" // {
      default = defaultEnabled;
      description = "Enable development packages (auto-enabled on desktop/laptop)";
    };
    
    ides = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && (deviceType != "minimal-laptop");
        description = "Install IDEs (JetBrains, VSCode, Android Studio)";
      };
    };
    
    cli-tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Install CLI development tools";
      };
    };
    
    languages = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Install language runtimes and tools";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Always include lightweight tools
    ] ++ lib.optionals cfg.cli-tools.enable [
      # CLI development tools
      gh
      lazydocker
      just
      gnumake
      bruno
      jq
    ] ++ lib.optionals cfg.languages.enable [
      # Language runtimes
      nodejs
    ] ++ lib.optionals cfg.ides.enable [
      # Heavy IDEs - only on full desktop/laptop setups
      vscode
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      jetbrains.clion
      android-studio
      codeblocksFull
    ];
  };
}