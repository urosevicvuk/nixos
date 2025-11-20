{
  # Disko configuration for anorLondo (Desktop)
  # BTRFS + impermanence (NO encryption - desktop use)
  #
  # This config is NOT imported yet - it's here for review
  #
  # ═══════════════════════════════════════════════════════════════════════
  # INSTALLATION PROCESS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. BOOT FROM NIXOS INSTALLER
  #
  # 2. RUN DISKO TO PARTITION AND FORMAT:
  #    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko \
  #      -- --mode disko /path/to/this/file
  #
  # 3. INSTALL NIXOS:
  #    After disko completes, install NixOS as normal
  #
  # 4. AFTER INSTALL, ADD BACK NTFS DATA DRIVES:
  #    Add the mount configurations to hardware-configuration.nix (see bottom of file)
  #
  # ═══════════════════════════════════════════════════════════════════════
  #
  # IMPORTANT NOTES:
  # - This config ONLY touches the main NVMe system disk
  # - Your NTFS data drives (/media/hdd4tb, /media/hdd750gb) are NOT affected
  # - No encryption on desktop (convenient for single-user gaming/work machine)
  # - If you want encryption later, switch to LUKS like ariandel
  #
  # ═══════════════════════════════════════════════════════════════════════

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Adjust this to your actual system disk!
        content = {
          type = "gpt";
          partitions = {
            # ─────────────────────────────────────────────────────────────
            # EFI System Partition
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
            # Swap partition (unencrypted)
            # ─────────────────────────────────────────────────────────────
            swap = {
              size = "32G"; # Adjust based on your RAM
              content = {
                type = "swap";
              };
            };

            # ─────────────────────────────────────────────────────────────
            # Root partition with BTRFS (unencrypted)
            # ─────────────────────────────────────────────────────────────
            root = {
              size = "100%";
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

                  # Nix store - persistent
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
  };

  # ═══════════════════════════════════════════════════════════════════════
  # WHAT YOU GET
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Disk layout:
  # /dev/nvme0n1
  # ├─ nvme0n1p1: EFI System Partition (1GB)
  # ├─ nvme0n1p2: Swap (32GB)
  # └─ nvme0n1p3: BTRFS root (remaining space)
  #    ├─ @ (ephemeral root)
  #    ├─ @nix (persistent)
  #    ├─ @persist (persistent)
  #    ├─ @home (persistent)
  #    └─ @log (persistent)
  #
  # Additional disks (NOT managed by disko - add manually after install):
  # /dev/sda: 4TB HDD (NTFS, Windows-compatible data storage)
  # /dev/sdb: 750GB HDD (NTFS, Windows-compatible data storage)
  #
  # Features:
  # ✓ BTRFS compression (zstd)
  # ✓ Impermanence (ephemeral root)
  # ✓ Secure Boot (via lanzaboote)
  # ✓ Windows dual-boot ready
  # ✓ Fast boot (no decryption needed)
  #
  # Security note:
  # - No encryption on desktop for convenience
  # - If you need encryption, use LUKS like ariandel config
  # - Physical security is your responsibility!
  #
  # ═══════════════════════════════════════════════════════════════════════
  #
  # AFTER INSTALL: Add these to hardware-configuration.nix
  # ═══════════════════════════════════════════════════════════════════════
  #
  # fileSystems."/media/hdd4tb" = {
  #   device = "/dev/disk/by-uuid/D24C8ECC4C8EAB35";
  #   fsType = "ntfs-3g";
  #   options = [ "rw" "uid=1000" "nofail" ];
  # };
  #
  # fileSystems."/media/hdd750gb" = {
  #   device = "/dev/disk/by-uuid/44FA0A84FA0A730A";
  #   fsType = "ntfs-3g";
  #   options = [ "rw" "uid=1000" "nofail" ];
  # };
  #
  # ═══════════════════════════════════════════════════════════════════════
}
