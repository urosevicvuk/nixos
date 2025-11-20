# Secrets configuration for sops-nix
# This file defines all keys and secret paths for the entire configuration
#
# To generate .sops.yaml:
#   nix eval --raw .#sopsConfig > .sops.yaml

{
  # ═══════════════════════════════════════════════════════════════════════
  # SSH KEYS
  # ═══════════════════════════════════════════════════════════════════════

  keys = {
    # Your personal SSH key (from ~/.ssh/id_ed25519.pub)
    # This is the ONLY key you need - use it everywhere!
    users = {
      vyke = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQpgKiftVTzqkfu6zbRpvZFtWZH/HBQSj6DhuVvVRul vuk23urosevic@gmail.com";
    };

    # Host keys (optional - if you want machines to decrypt their own secrets)
    # You can leave these empty if you just use your personal key
    hosts = {
      ariandel = ""; # ssh-ed25519 AAAAC3... (from /etc/ssh/ssh_host_ed25519_key.pub)
      anorLondo = ""; # ssh-ed25519 AAAAC3...
      firelink = ""; # ssh-ed25519 AAAAC3...
    };
  };

  # ═══════════════════════════════════════════════════════════════════════
  # SECRET PATHS
  # ═══════════════════════════════════════════════════════════════════════

  # Define which secrets exist for each host
  secretPaths = {
    # Secrets for ariandel (laptop)
    ariandel = [
      "secrets/ariandel/wifi.yaml"
      "secrets/ariandel/user-passwords.yaml"
      # Add more as needed
    ];

    # Secrets for anorLondo (desktop)
    anorLondo = [
      "secrets/anorLondo/user-passwords.yaml"
      # Add more as needed
    ];

    # Secrets for firelink (server)
    firelink = [
      "secrets/firelink/user-passwords.yaml"
      "secrets/firelink/nextcloud.yaml"
      "secrets/firelink/tailscale.yaml"
      # Add more as needed
    ];

    # Shared secrets (all hosts can decrypt)
    shared = [
      "secrets/shared/common.yaml"
    ];
  };
}
