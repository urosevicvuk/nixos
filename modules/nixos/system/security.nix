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
      # Hyprlock authentication - conditional based on device
      hyprlock = if isLaptop then {
        # Custom PAM config for fingerprint OR password (not both)
        text = ''
          auth sufficient pam_fprintd.so
          auth include login
        '';
      } else {
        text = "auth include login";  # Password only on desktop
      };

      # Fingerprint authentication for various services (laptop only)
      sudo.fprintAuth = lib.mkIf isLaptop true;           # Sudo authentication
      login.fprintAuth = lib.mkIf isLaptop true;          # Login at boot (greetd/tuigreet)
      greetd.fprintAuth = lib.mkIf isLaptop true;         # Greetd display manager
      polkit-1.fprintAuth = lib.mkIf isLaptop true;       # GUI admin prompts
      gnome-keyring.fprintAuth = lib.mkIf isLaptop true;  # GNOME Keyring unlock
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
