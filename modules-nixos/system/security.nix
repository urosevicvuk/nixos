{ config, lib, ... }:
let
  inherit (config.var) username;
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  # Fingerprint authentication (laptop only)
  services.fprintd.enable = isLaptop;

  security = {
    # PAM services configuration
    pam.services = {

      hyprlock = {
        text = "auth include login";
        fprintAuth = lib.mkIf isLaptop true;
      };

      # Fingerprint authentication for various services (laptop only)
      sudo.fprintAuth = lib.mkIf isLaptop true;
      login = {
        fprintAuth = lib.mkIf isLaptop true;
        enableGnomeKeyring = true;
      };
      greetd = {
        # Session logins are disabled by default
        fprintAuth = false;
        enableGnomeKeyring = true;
      };
      polkit-1.fprintAuth = lib.mkIf isLaptop true;
    };

    # Userland niceness for realtime audio
    rtkit.enable = true;

    # Sudo configuration
    sudo = {
      # Require authentication (fingerprint or password) for wheel group
      wheelNeedsPassword = true;

      # Sudo rules for specific commands
      extraRules = [
        # Allow nixos-rebuild without password
        {
          users = [ username ];
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
        }
        # Allow tailscale without password
        {
          users = [ username ];
          commands = [
            {
              command = "/etc/profiles/per-user/${username}/bin/tailscale";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/tailscale";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
