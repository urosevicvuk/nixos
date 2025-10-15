{ config, pkgs, ... }:

{
  # RLCraft Minecraft Server (Forge 1.12.2)
  # Manual setup required after first deployment - see comments below

  systemd.services.rlcraft-server = {
    enable = true;
    description = "RLCraft Forge Minecraft Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Run as the minecraft user (created by nix-minecraft)
      User = "minecraft";
      Group = "minecraft";

      # Working directory for RLCraft server
      WorkingDirectory = "/var/lib/minecraft/rlcraft";

      # Java 8 required for Minecraft 1.12.2
      # RLCraft needs 6-8GB RAM
      ExecStart = "${pkgs.jre8}/bin/java -Xms6G -Xmx8G -jar forge.jar nogui";

      # Restart policy
      Restart = "always";
      RestartSec = "60s";

      # Security hardening (similar to nix-minecraft)
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = true;

      # Allow writes to the working directory
      ReadWritePaths = [ "/var/lib/minecraft/rlcraft" ];
    };
  };

  # Ensure the working directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft 0755 minecraft minecraft -"
    "d /var/lib/minecraft/rlcraft 0755 minecraft minecraft -"
  ];
}

# MANUAL SETUP REQUIRED AFTER FIRST DEPLOYMENT:
#
# 1. Download RLCraft Server Pack 2.9.3:
#    wget https://www.curseforge.com/minecraft/modpacks/rlcraft/download/4612990/file -O rlcraft-server.zip
#
# 2. Download Forge 1.12.2-14.23.5.2860 installer:
#    wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2860/forge-1.12.2-14.23.5.2860-installer.jar
#
# 3. Extract RLCraft to /var/lib/minecraft/rlcraft:
#    sudo unzip rlcraft-server.zip -d /var/lib/minecraft/rlcraft/
#
# 4. Run Forge installer:
#    cd /var/lib/minecraft/rlcraft
#    sudo java -jar forge-1.12.2-14.23.5.2860-installer.jar --installServer
#
# 5. Accept EULA:
#    echo "eula=true" | sudo tee /var/lib/minecraft/rlcraft/eula.txt
#
# 6. Create symlink to forge jar:
#    sudo ln -sf forge-1.12.2-14.23.5.2860.jar /var/lib/minecraft/rlcraft/forge.jar
#
# 7. Configure server.properties:
#    echo "enable-command-block=true" | sudo tee -a /var/lib/minecraft/rlcraft/server.properties
#    echo "server-port=25566" | sudo tee -a /var/lib/minecraft/rlcraft/server.properties
#    echo "server-ip=127.0.0.1" | sudo tee -a /var/lib/minecraft/rlcraft/server.properties
#
# 8. Fix permissions:
#    sudo chown -R minecraft:minecraft /var/lib/minecraft/rlcraft
#
# 9. Start the server:
#    sudo systemctl start rlcraft-server
#
# 10. Check status and logs:
#     sudo systemctl status rlcraft-server
#     sudo journalctl -u rlcraft-server -f
