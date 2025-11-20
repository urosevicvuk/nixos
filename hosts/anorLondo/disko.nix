{
  # Disko configuration for anorLondo (Desktop)
  # This config is NOT imported yet - it's here for review
  #
  # To use this config:
  # 1. Boot from NixOS installer
  # 2. Run: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/this/file
  # 3. This will wipe and repartition your disk according to this config
  # 4. Then install NixOS normally
  #
  # IMPORTANT:
  # - Adjust the disk device path below to match your system!
  # - This ONLY touches the main NVMe system disk
  # - Your NTFS data drives (/media/hdd4tb, /media/hdd750gb) are NOT affected
  # - You'll need to add those mounts back in hardware-configuration.nix after install

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Adjust this to your actual system disk!
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
              size = "32G"; # Adjust based on your RAM
              content = {
                type = "swap";
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

  # NOTE: After installing with this config, remember to add back your NTFS drives:
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
}
