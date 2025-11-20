{
  # Disko configuration for firelink (Server)
  # ZFS + native encryption + automatic snapshots
  #
  # This config is NOT imported yet - it's here for review
  #
  # ⚠️  WARNING: This is a PRODUCTION SERVER configuration!
  # ⚠️  Test impermanence thoroughly on ariandel before using this!
  #
  # ═══════════════════════════════════════════════════════════════════════
  # INSTALLATION PROCESS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. BACK UP EVERYTHING FIRST!
  #
  # 2. BOOT FROM NIXOS INSTALLER
  #
  # 3. CREATE ENCRYPTION PASSWORD FILE (temporary, for disko):
  #    echo "your-strong-server-password" > /tmp/zfs-password.txt
  #
  # 4. RUN DISKO TO PARTITION AND FORMAT:
  #    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko \
  #      -- --mode disko /path/to/this/file
  #
  # 5. INSTALL NIXOS:
  #    After disko completes, install NixOS as normal
  #    On first boot, you'll be prompted for the ZFS encryption password
  #
  # 6. VERIFY ZFS SETUP:
  #    zpool status
  #    zfs list
  #
  # ═══════════════════════════════════════════════════════════════════════

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # ⚠️  VERIFY THIS! Check with lsblk on your system!
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
            # ZFS Pool (encrypted)
            # ─────────────────────────────────────────────────────────────
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════
    # ZFS Pool Configuration
    # ═══════════════════════════════════════════════════════════════════════
    zpool = {
      zroot = {
        type = "zpool";

        # ZFS pool options (optimized for server)
        options = {
          ashift = "12"; # 4K sectors (standard for modern disks)
          autotrim = "on"; # SSD trim support
        };

        # Root filesystem options
        rootFsOptions = {
          compression = "zstd"; # Better than lz4, similar speed
          acltype = "posixacl";
          xattr = "sa";
          atime = "off"; # Better performance
          "com.sun:auto-snapshot" = "true"; # Enable auto-snapshots
        };

        # ═══════════════════════════════════════════════════════════════
        # ZFS Datasets (like BTRFS subvolumes)
        # ═══════════════════════════════════════════════════════════════
        datasets = {
          # ─────────────────────────────────────────────────────────────
          # Encrypted datasets
          # ─────────────────────────────────────────────────────────────

          # Root dataset - ephemeral (wiped on boot with impermanence)
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
            };
            postCreateHook = "zfs snapshot zroot/root@blank";
          };

          # Nix store - persistent, encrypted
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              atime = "off";
              canmount = "on";
            };
          };

          # Persistent data - encrypted, critical for server state
          "persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              "com.sun:auto-snapshot" = "true"; # Snapshot this!
            };
          };

          # Home directory - encrypted, persistent
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # Logs - encrypted, persistent (important for servers!)
          "log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # ─────────────────────────────────────────────────────────────
          # Service-specific datasets (all encrypted)
          # ─────────────────────────────────────────────────────────────

          # Docker data
          "docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # Nextcloud data (critical!)
          "nextcloud" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/nextcloud";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              recordsize = "1M"; # Optimized for large files
              "com.sun:auto-snapshot" = "true";
            };
          };

          # PostgreSQL data
          "postgres" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/postgresql";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              recordsize = "8K"; # Optimized for databases
              logbias = "throughput";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # Redis data
          "redis" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/redis";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              primarycache = "metadata"; # Optimized for Redis
              "com.sun:auto-snapshot" = "true";
            };
          };

          # ─────────────────────────────────────────────────────────────
          # Swap (encrypted via ZFS ZVOL)
          # ─────────────────────────────────────────────────────────────
          "swap" = {
            type = "zfs_volume";
            size = "16G"; # Adjust based on server RAM
            content = {
              type = "swap";
            };
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/zfs-password.txt";
              compression = "zle"; # Fast compression for swap
              sync = "always";
              primarycache = "metadata";
              secondarycache = "none";
              logbias = "throughput";
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
  # /dev/sda
  # ├─ sda1: EFI System Partition (1GB, unencrypted)
  # └─ sda2: ZFS pool "zroot" (remaining space, encrypted)
  #    ├─ zroot/root        (/, ephemeral)
  #    ├─ zroot/nix         (/nix, persistent)
  #    ├─ zroot/persist     (/persist, persistent, snapshotted)
  #    ├─ zroot/home        (/home, persistent, snapshotted)
  #    ├─ zroot/log         (/var/log, persistent, snapshotted)
  #    ├─ zroot/docker      (/var/lib/docker, persistent, snapshotted)
  #    ├─ zroot/nextcloud   (/var/lib/nextcloud, persistent, snapshotted)
  #    ├─ zroot/postgres    (/var/lib/postgresql, persistent, snapshotted)
  #    ├─ zroot/redis       (/var/lib/redis, persistent, snapshotted)
  #    └─ zroot/swap        (16GB encrypted swap)
  #
  # ZFS features:
  # ✓ Native encryption (AES-256-GCM)
  # ✓ Data integrity (end-to-end checksumming)
  # ✓ Automatic snapshots enabled
  # ✓ Compression (zstd)
  # ✓ Per-dataset optimization (recordsize for workload)
  # ✓ ARC cache for performance
  # ✓ Self-healing on scrub
  # ✓ Efficient snapshots (copy-on-write)
  #
  # Security features:
  # ✓ Full encryption (native ZFS encryption)
  # ✓ Encrypted swap
  # ✓ Impermanence (ephemeral root)
  # ✓ Secure Boot (via lanzaboote)
  # ✓ Tailscale-only SSH access
  #
  # ═══════════════════════════════════════════════════════════════════════
}
