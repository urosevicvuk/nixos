{
  # Disko configuration for ariandel (Framework laptop)
  # BTRFS + LUKS encryption + TPM2 auto-unlock + encrypted swap
  #
  # This config is NOT imported yet - it's here for review
  #
  # ═══════════════════════════════════════════════════════════════════════
  # INSTALLATION PROCESS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. BOOT FROM NIXOS INSTALLER
  #
  # 2. CREATE ENCRYPTION PASSWORD FILE (temporary, for disko):
  #    echo "your-strong-password" > /tmp/disk-password.txt
  #
  # 3. RUN DISKO TO PARTITION AND FORMAT:
  #    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko \
  #      -- --mode disko /path/to/this/file
  #    (You'll be prompted for the LUKS password during install)
  #
  # 4. INSTALL NIXOS:
  #    After disko completes, install NixOS as normal
  #
  # 5. AFTER FIRST BOOT, ENROLL TPM2 (optional but recommended):
  #    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p3
  #    (This allows auto-unlock on normal boot while keeping password fallback)
  #
  # ═══════════════════════════════════════════════════════════════════════

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Adjust this to your actual disk!
        content = {
          type = "gpt";
          partitions = {
            # ─────────────────────────────────────────────────────────────
            # EFI System Partition (unencrypted - required for boot)
            # ─────────────────────────────────────────────────────────────
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };

            # ─────────────────────────────────────────────────────────────
            # LUKS Encrypted Partition
            # Contains: BTRFS with all subvolumes + swap
            # ─────────────────────────────────────────────────────────────
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted"; # This will appear as /dev/mapper/crypted

                # Password file for installation (create before running disko)
                # After install, you can enroll TPM2 for auto-unlock
                passwordFile = "/tmp/disk-password.txt";

                settings = {
                  allowDiscards = true; # Important for SSD performance
                };

                # What's inside the encrypted volume:
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════
    # LVM Volume Group (inside LUKS)
    # ═══════════════════════════════════════════════════════════════════════
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          # ───────────────────────────────────────────────────────────────
          # Encrypted Swap (for hibernate support)
          # ───────────────────────────────────────────────────────────────
          swap = {
            size = "24G"; # Match or exceed your RAM for hibernate
            content = {
              type = "swap";
              resumeDevice = true; # Enable hibernate
            };
          };

          # ───────────────────────────────────────────────────────────────
          # Root filesystem (BTRFS with subvolumes)
          # ───────────────────────────────────────────────────────────────
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Force formatting

              # BTRFS subvolumes for impermanence
              subvolumes = {
                # Root subvolume - ephemeral, wiped on boot
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                # Nix store - persistent (obviously!)
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                # Persistent data - survives reboots
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                # Home directory - persistent user data
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                # Logs - persistent
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════
  # WHAT YOU GET
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Disk layout:
  # /dev/nvme0n1
  # ├─ nvme0n1p1: EFI System Partition (1GB, unencrypted)
  # └─ nvme0n1p2: LUKS encrypted container
  #    └─ /dev/mapper/crypted (LVM Physical Volume)
  #       └─ pool (Volume Group)
  #          ├─ swap (24GB, encrypted swap)
  #          └─ root (remaining space, BTRFS)
  #             ├─ @ (ephemeral root)
  #             ├─ @nix (persistent)
  #             ├─ @persist (persistent)
  #             ├─ @home (persistent)
  #             └─ @log (persistent)
  #
  # Security features:
  # ✓ Full disk encryption (except /boot)
  # ✓ Encrypted swap (safe for hibernate)
  # ✓ TPM2 auto-unlock (after enrollment)
  # ✓ Password fallback (if TPM fails)
  # ✓ Secure Boot (via lanzaboote)
  # ✓ Impermanence (ephemeral root)
  #
  # ═══════════════════════════════════════════════════════════════════════
}
