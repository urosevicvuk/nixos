{
  # Disko configuration for ariandel (Framework laptop)
  # This config is NOT imported yet - it's here for review
  #
  # To use this config:
  # 1. Boot from NixOS installer
  # 2. Run: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/this/file
  # 3. This will wipe and repartition your disk according to this config
  # 4. Then install NixOS normally
  #
  # IMPORTANT: Adjust the disk device path below to match your system!
  # Use `lsblk` to find your disk (probably /dev/nvme0n1)

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Adjust this to your actual disk!
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
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };

            # Swap partition (for hibernate support)
            swap = {
              size = "24G"; # Adjust based on your RAM
              content = {
                type = "swap";
                resumeDevice = true; # Enable hibernate support
              };
            };

            # Root partition with BTRFS
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
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # Nix store - persistent (obviously!)
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # Persistent data - survives reboots
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # Home directory - persistent user data
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # Logs - persistent
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
