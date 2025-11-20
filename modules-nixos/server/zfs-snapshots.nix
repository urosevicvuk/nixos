{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ZFS Automatic Snapshots
  # Automated snapshot management for ZFS datasets
  #
  # This module is NOT imported yet - it's for firelink (server) only
  #
  # ═══════════════════════════════════════════════════════════════════════
  # WHAT THIS DOES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # ZFS snapshots are instant, space-efficient point-in-time copies:
  # - Take seconds to create (copy-on-write)
  # - Use minimal space (only stores changes)
  # - Perfect for backup and recovery
  # - Can be sent to remote systems
  #
  # This module sets up automatic snapshots with retention policies:
  # - Frequent: Every 15 minutes, keep 4 (last hour)
  # - Hourly: Every hour, keep 24 (last day)
  # - Daily: Every day, keep 7 (last week)
  # - Weekly: Every week, keep 4 (last month)
  # - Monthly: Every month, keep 12 (last year)
  #
  # ═══════════════════════════════════════════════════════════════════════
  # CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════

  services.sanoid = {
    enable = true;

    # Global settings
    settings = {
      # ─────────────────────────────────────────────────────────────────
      # Template: Production (for critical data)
      # ─────────────────────────────────────────────────────────────────
      "template_production" = {
        frequently = 4; # Every 15 min, keep 4 (last hour)
        hourly = 24; # Every hour, keep 24 (last day)
        daily = 7; # Every day, keep 7 (last week)
        weekly = 4; # Every week, keep 4 (last month)
        monthly = 12; # Every month, keep 12 (last year)
        autosnap = true;
        autoprune = true;
      };

      # ─────────────────────────────────────────────────────────────────
      # Template: Standard (for regular data)
      # ─────────────────────────────────────────────────────────────────
      "template_standard" = {
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 6;
        autosnap = true;
        autoprune = true;
      };

      # ─────────────────────────────────────────────────────────────────
      # Template: Minimal (for less critical data)
      # ─────────────────────────────────────────────────────────────────
      "template_minimal" = {
        daily = 3;
        weekly = 2;
        autosnap = true;
        autoprune = true;
      };

      # ═══════════════════════════════════════════════════════════════
      # Dataset Configurations
      # ═══════════════════════════════════════════════════════════════

      # Persistent data (CRITICAL - production template)
      "zroot/persist" = {
        use_template = "production";
        recursive = true; # Snapshot all child datasets
      };

      # Nextcloud data (CRITICAL - production template)
      "zroot/nextcloud" = {
        use_template = "production";
      };

      # PostgreSQL (CRITICAL - production template)
      "zroot/postgres" = {
        use_template = "production";
      };

      # Home directory (standard template)
      "zroot/home" = {
        use_template = "standard";
      };

      # Docker volumes (standard template)
      "zroot/docker" = {
        use_template = "standard";
      };

      # Redis (standard template)
      "zroot/redis" = {
        use_template = "standard";
      };

      # Logs (minimal template - grows fast)
      "zroot/log" = {
        use_template = "minimal";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════
  # ADDITIONAL ZFS MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════

  # Automatic scrubbing (data integrity check)
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly"; # Check data integrity monthly
    pools = [ "zroot" ];
  };

  # ZFS auto-snapshot service
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --syslog";
    frequent = 4; # 15-minute snapshots
    hourly = 24;
    daily = 7;
    weekly = 4;
    monthly = 12;
  };

  # ═══════════════════════════════════════════════════════════════════════
  # USAGE INSTRUCTIONS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # VIEW SNAPSHOTS:
  #    zfs list -t snapshot
  #    (Shows all snapshots)
  #
  #    zfs list -t snapshot zroot/nextcloud
  #    (Shows snapshots for specific dataset)
  #
  # RESTORE FROM SNAPSHOT:
  #    # List available snapshots
  #    zfs list -t snapshot zroot/nextcloud
  #
  #    # Rollback to specific snapshot (DESTRUCTIVE - loses newer data!)
  #    zfs rollback zroot/nextcloud@autosnap_2025-11-20_14:00:00
  #
  #    # OR: Clone snapshot to browse files (non-destructive)
  #    zfs clone zroot/nextcloud@autosnap_2025-11-20_14:00:00 zroot/nextcloud_recovery
  #    ls /zroot/nextcloud_recovery
  #    # Copy files you need, then destroy clone:
  #    zfs destroy zroot/nextcloud_recovery
  #
  # MANUAL SNAPSHOT:
  #    zfs snapshot zroot/nextcloud@before-upgrade
  #
  # DELETE SNAPSHOT:
  #    zfs destroy zroot/nextcloud@snapshot-name
  #
  # SEND SNAPSHOT TO REMOTE BACKUP:
  #    # Initial full backup
  #    zfs send zroot/nextcloud@latest | ssh backup-server "zfs receive backup/nextcloud"
  #
  #    # Incremental backup (after initial)
  #    zfs send -i zroot/nextcloud@previous zroot/nextcloud@latest | \
  #      ssh backup-server "zfs receive backup/nextcloud"
  #
  # ═══════════════════════════════════════════════════════════════════════
  # MONITORING
  # ═══════════════════════════════════════════════════════════════════════
  #
  # CHECK POOL HEALTH:
  #    zpool status
  #    (Should show "ONLINE" and no errors)
  #
  # CHECK DISK USAGE:
  #    zfs list
  #    (Shows space used by each dataset + snapshots)
  #
  # CHECK SNAPSHOT SPACE:
  #    zfs list -o space
  #    (Shows how much space snapshots are using)
  #
  # CHECK SCRUB STATUS:
  #    zpool status -v
  #    (Shows last scrub time and results)
  #
  # VIEW SANOID LOGS:
  #    sudo journalctl -u sanoid -f
  #
  # ═══════════════════════════════════════════════════════════════════════
  # RECOVERY SCENARIOS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # SCENARIO 1: Accidental file deletion (in last hour)
  # 1. Find the snapshot before deletion:
  #    zfs list -t snapshot -o name,creation zroot/nextcloud
  # 2. Clone the snapshot:
  #    zfs clone zroot/nextcloud@recent-snapshot zroot/temp
  # 3. Copy the file back:
  #    cp /zroot/temp/path/to/file /var/lib/nextcloud/path/to/file
  # 4. Clean up:
  #    zfs destroy zroot/temp
  #
  # SCENARIO 2: Database corruption
  # 1. Stop the service:
  #    systemctl stop postgresql
  # 2. Rollback to last good snapshot:
  #    zfs rollback zroot/postgres@autosnap_recent
  # 3. Restart service:
  #    systemctl start postgresql
  #
  # SCENARIO 3: Bad software update
  # 1. Rollback entire persist dataset:
  #    zfs rollback -r zroot/persist@before-update
  # 2. Reboot
  #
  # SCENARIO 4: Hardware failure (with remote backup)
  # 1. Install NixOS on new hardware with disko
  # 2. Restore from remote backup:
  #    ssh backup-server "zfs send backup/nextcloud@latest" | \
  #      zfs receive zroot/nextcloud
  #
  # ═══════════════════════════════════════════════════════════════════════
  # SPACE MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Snapshots use space as files change. Monitor with:
  #    zfs list -o space,used,avail,refer,usedsnap,usedds
  #
  # If snapshots use too much space:
  # 1. Check which dataset has most snapshot usage:
  #    zfs list -o name,usedsnap -s usedsnap
  #
  # 2. Adjust retention policies (edit this file):
  #    - Reduce number of snapshots kept
  #    - Reduce snapshot frequency
  #
  # 3. Manually delete old snapshots:
  #    zfs list -t snapshot -s creation zroot/dataset | head -20
  #    zfs destroy zroot/dataset@old-snapshot
  #
  # ═══════════════════════════════════════════════════════════════════════
  # BEST PRACTICES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. ALWAYS take a manual snapshot before major changes:
  #    zfs snapshot zroot/nextcloud@before-upgrade-$(date +%Y%m%d)
  #
  # 2. Test recovery procedures regularly:
  #    - Practice cloning snapshots
  #    - Practice rollbacks on non-critical data
  #
  # 3. Monitor disk space:
  #    - Set up alerts when pool > 80% full
  #    - ZFS performance degrades above 80%
  #
  # 4. Scrub regularly (automated monthly):
  #    - Detects silent data corruption
  #    - Self-heals when possible
  #
  # 5. Consider remote backups:
  #    - zfs send/receive to another machine
  #    - Or use syncoid (companion to sanoid)
  #
  # 6. Keep at least one "golden" snapshot:
  #    - Right after clean install
  #    - Hold it indefinitely for reference
  #
  # ═══════════════════════════════════════════════════════════════════════
}
