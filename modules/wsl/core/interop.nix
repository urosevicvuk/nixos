# Windows Interoperability
#
# Configuration for Windows-WSL interop features.
# Access Windows programs from WSL and vice versa.

{ config, lib, pkgs, ... }:
let
  cfg = config.modules.wsl.interop;
in
{
  options.modules.wsl.interop = {
    enable = lib.mkEnableOption "Windows interop features" // {
      default = true;
      description = "Enable Windows-WSL interoperability";
    };

    includePath = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include Windows PATH in WSL";
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      # Enable running Windows executables from WSL
      interop.enabled = true;

      # Include Windows PATH
      interop.includePath = cfg.includePath;
    };

    # Useful Windows interop packages
    environment.systemPackages = with pkgs; [
      # wslu - utilities for WSL
      wslu
    ];

    # Example: Add aliases for common Windows apps
    environment.shellAliases = {
      # explorer = "explorer.exe";
      # code = "code.exe";
      # pwsh = "powershell.exe";
    };

    # Systemd services can interact with Windows
    # Example: Mount Windows drives
    # fileSystems."/mnt/c" = {
    #   device = "C:";
    #   fsType = "drvfs";
    # };
  };
}
