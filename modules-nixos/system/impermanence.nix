{
  config,
  lib,
  ...
}:
{
  # Impermanence - Ephemeral root filesystem
  # https://github.com/nix-community/impermanence
  #
  # This module is NOT imported yet - it's here for review and configuration
  #
  # ═══════════════════════════════════════════════════════════════════════
  # WHAT IS IMPERMANENCE?
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Impermanence makes your root filesystem ephemeral (temporary). On every boot,
  # the root filesystem is wiped clean, and only explicitly persisted files/folders
  # remain. This gives you:
  #
  # ✅ A clean system every boot (no accumulated cruft)
  # ✅ Explicit declaration of what state matters
  # ✅ Better security (malware can't persist unless you explicitly allow it)
  # ✅ Easier system management (you know exactly what's persistent)
  #
  # ❓ HOW DOES IT WORK?
  #
  # With BTRFS subvolumes (from disko config):
  #   /       -> @ subvolume (ephemeral, wiped on boot)
  #   /nix    -> @nix subvolume (persistent, obviously!)
  #   /persist -> @persist subvolume (persistent data)
  #   /home   -> @home subvolume (persistent user files)
  #   /var/log -> @log subvolume (persistent logs)
  #
  # Anything you want to survive reboots must be:
  # 1. In a persistent subvolume (/nix, /persist, /home, /var/log), OR
  # 2. Explicitly listed in the persistence configuration below
  #
  # ═══════════════════════════════════════════════════════════════════════
  # CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════

  environment.persistence."/persist" = {
    # Hide the /persist directory in file browsers
    # You don't need to manually interact with it
    hideMounts = true;

    # ───────────────────────────────────────────────────────────────────
    # SYSTEM DIRECTORIES - Things the system needs to remember
    # ───────────────────────────────────────────────────────────────────
    directories = [
      # Network configuration
      "/etc/NetworkManager/system-connections" # WiFi passwords, VPN configs

      # SSH host keys (IMPORTANT: without this, SSH host keys regenerate on every boot!)
      "/etc/ssh"

      # System logs (already on @log subvolume, but listed for clarity)
      # "/var/log"

      # Systemd timers and persistent state
      "/var/lib/systemd/timers"
      "/var/lib/systemd/coredump"

      # Bluetooth device pairings
      "/var/lib/bluetooth"

      # CUPS (printing) configuration
      # "/var/lib/cups"

      # Docker data (if using Docker)
      # Note: For firelink, this is on @docker subvolume
      # "/var/lib/docker"

      # Tailscale state (VPN)
      "/var/lib/tailscale"

      # SOPS keys and secrets
      "/var/lib/sops-nix"

      # Hardware state (e.g., fingerprint reader data)
      "/var/lib/fprint" # For laptops with fingerprint readers

      # Any other service state you need:
      # "/var/lib/nextcloud"  # Server only
      # "/var/lib/postgresql" # Server only
      # "/var/lib/redis"      # Server only
      # "/var/lib/docker"     # If using Docker
    ];

    # ───────────────────────────────────────────────────────────────────
    # SYSTEM FILES - Individual files that need to persist
    # ───────────────────────────────────────────────────────────────────
    files = [
      # Machine ID (important for many services)
      "/etc/machine-id"

      # Any other critical system files:
      # "/etc/nix/id_rsa" # If you have binary cache signing keys
    ];

    # ───────────────────────────────────────────────────────────────────
    # USER-LEVEL PERSISTENCE
    # ───────────────────────────────────────────────────────────────────
    users.${config.var.username} = {
      directories = [
        # User-level persistence
        # Note: Most user files are in /home which is already persistent (@home subvolume)
        # These are for dotfiles and configs in non-home locations

        # Application caches (optional - these can be ephemeral)
        # ".cache/mozilla"
        # ".cache/chromium"

        # Application data
        # ".mozilla/firefox"
        # ".config/discord"
        # ".config/spotify"

        # SSH keys
        ".ssh"

        # GPG keys
        ".gnupg"

        # Local state (for apps that store state in ~/.local)
        # ".local/share/nvim"
        # ".local/share/Steam"

        # Anything else you want to persist outside of /home
      ];

      files = [
        # User-level files that need to persist
        # Usually not needed since /home is persistent
      ];
    };
  };

  # ═══════════════════════════════════════════════════════════════════════
  # WHAT GETS WIPED?
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Everything NOT listed above and NOT in persistent subvolumes:
  #
  # ✅ WIPED ON EVERY BOOT:
  # - /tmp (temporary files)
  # - /var/tmp (temporary files)
  # - Downloaded installers and one-time files
  # - Application caches (unless persisted)
  # - Browser cache (unless persisted)
  # - Any files created in root filesystem
  # - Logs not in /var/log (since @log is persistent)
  #
  # ❌ NEVER WIPED (persistent):
  # - /nix (all packages and system configs)
  # - /persist (anything you explicitly persist)
  # - /home (all user files)
  # - /var/log (system logs)
  # - Anything listed in directories/files above
  #
  # ═══════════════════════════════════════════════════════════════════════
  # TESTING IMPERMANENCE
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. After enabling impermanence and rebooting, test that things work:
  #    - Can you connect to WiFi? (NetworkManager connections should persist)
  #    - Can you SSH without warnings? (host keys should persist)
  #    - Are Bluetooth devices still paired? (bluetooth state should persist)
  #    - Do your services work? (service state should persist)
  #
  # 2. If something doesn't persist that should:
  #    a. Figure out where it stores its state (check /var/lib/<service>)
  #    b. Add that path to directories = [ ... ] above
  #    c. Rebuild and reboot
  #
  # 3. Common issues and fixes:
  #    - "SSH host key changed" warning -> Add "/etc/ssh" to directories
  #    - WiFi passwords forgotten -> Add "/etc/NetworkManager/system-connections"
  #    - Bluetooth devices unpaired -> Add "/var/lib/bluetooth"
  #    - Service state lost -> Add "/var/lib/<service-name>"
  #
  # ═══════════════════════════════════════════════════════════════════════
  # ENABLING THIS MODULE
  # ═══════════════════════════════════════════════════════════════════════
  #
  # To enable impermanence:
  #
  # 1. Install NixOS using the disko configuration (wipes disk!)
  # 2. Import this module in your host configuration:
  #    imports = [ ../../modules-nixos/system/impermanence.nix ];
  # 3. Add impermanence module to flake.nix (already done!)
  # 4. Rebuild and test!
  #
  # Start with ariandel (laptop) to test, then apply to other hosts.
}
