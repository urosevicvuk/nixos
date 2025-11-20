{
  # Disko configuration for firelink (Server)
  # This config is NOT imported yet - it's here for review
  #
  # ⚠️  WARNING: This is a PRODUCTION SERVER configuration!
  # ⚠️  Test thoroughly on ariandel/anorLondo before using this!
  #
  # To use this config:
  # 1. Back up EVERYTHING first!
  # 2. Boot from NixOS installer
  # 3. Run: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/this/file
  # 4. This will wipe and repartition your disk according to this config
  # 5. Then install NixOS normally
  #
  # IMPORTANT:
  # - Adjust the disk device path below to match your system!
  # - This server has a MegaRAID controller - verify disk path carefully!
  # - Use `lsblk` to find your disk (might be /dev/sda or RAID device)
  # - For servers, consider ZFS instead of BTRFS for better data integrity

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # ⚠️  VERIFY THIS! Check with lsblk on your system!
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
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

            # Swap partition
            swap = {
              size = "16G"; # Adjust based on your server's RAM
              content = {
                type = "swap";
              };
            };

            # Root partition with BTRFS
            # Note: Consider using ZFS for production servers
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force formatting

                # BTRFS subvolumes for impermanence
                subvolumes = {
                  # Root subvolume - ephemeral
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
                  # This is critical for server state!
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  # Home directory - persistent
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  # Logs - persistent (important for servers!)
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  # Docker volumes - persistent
                  "@docker" = {
                    mountpoint = "/var/lib/docker";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  # Nextcloud data - persistent (obviously!)
                  "@nextcloud" = {
                    mountpoint = "/var/lib/nextcloud";
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

  # Server-specific notes:
  # - You'll need to persist ALL service data in /persist
  # - Docker, Nextcloud, PostgreSQL, Redis state must be carefully handled
  # - Consider ZFS for production for better snapshots and data integrity
  # - Test the impermanence setup on ariandel first!
}
