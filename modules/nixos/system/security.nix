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
    # Allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";

    # Fingerprint authentication for sudo (laptop only)
    pam.services.sudo = lib.mkIf isLaptop {
      fprintAuth = true;
    };

    # Userland niceness for realtime audio
    rtkit.enable = true;

    # Sudo configuration
    sudo = {
      # Don't ask for password for wheel group (disabled on laptop for fingerprint)
      wheelNeedsPassword = isLaptop;

      # Sudo rules for specific commands
      extraRules = [
        # Allow nixos-rebuild without password
        {
          users = [ username ];
          commands = [{
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }];
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
