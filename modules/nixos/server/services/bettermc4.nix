{ config, pkgs, ... }:

{
  # Better MC 4 Minecraft Server (Forge)
  # Manual setup required after first deployment - see comments below

  systemd.services.bettermc4-server = {
    enable = true;
    description = "Better MC 4 Forge Minecraft Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Run as the minecraft user (created by nix-minecraft)
      User = "minecraft";
      Group = "minecraft";

      # Working directory for Better MC 4 server
      WorkingDirectory = "/var/lib/minecraft/bettermc4";

      # Java 21 required for Minecraft 1.21.1
      # Better MC 4 needs 6-10GB RAM depending on player count
      ExecStart = "${pkgs.jdk21}/bin/java -Xms6G -Xmx10G -jar forge.jar nogui";

      # Restart policy
      Restart = "always";
      RestartSec = "60s";

      # Security hardening (similar to nix-minecraft)
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = true;

      # Allow writes to the working directory
      ReadWritePaths = [ "/var/lib/minecraft/bettermc4" ];
    };
  };

  # Ensure the working directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft 0755 minecraft minecraft -"
    "d /var/lib/minecraft/bettermc4 0755 minecraft minecraft -"
  ];
}

# MANUAL SETUP REQUIRED AFTER FIRST DEPLOYMENT:
#
# 1. Download Better MC 4 Server Pack:
#    Visit https://www.curseforge.com/minecraft/modpacks/better-mc-forge
#    Download the server files for the latest version
#    wget <server-pack-url> -O bettermc4-server.zip
#
# 2. Extract Better MC 4 to /var/lib/minecraft/bettermc4:
#    sudo unzip bettermc4-server.zip -d /var/lib/minecraft/bettermc4/
#
# 3. Run the Forge installer (if included) or install Forge manually:
#    cd /var/lib/minecraft/bettermc4
#    sudo java -jar forge-installer.jar --installServer
#
# 4. Accept EULA:
#    echo "eula=true" | sudo tee /var/lib/minecraft/bettermc4/eula.txt
#
# 5. Create symlink to forge jar (adjust version as needed):
#    cd /var/lib/minecraft/bettermc4
#    sudo ln -sf forge-*.jar forge.jar
#
# 6. Configure server.properties:
#    echo "server-port=25565" | sudo tee -a /var/lib/minecraft/bettermc4/server.properties
#    echo "server-ip=127.0.0.1" | sudo tee -a /var/lib/minecraft/bettermc4/server.properties
#
# 7. Fix permissions:
#    sudo chown -R minecraft:minecraft /var/lib/minecraft/bettermc4
#
# 8. Start the server:
#    sudo systemctl start bettermc4-server
#
# 9. Check status and logs:
#     sudo systemctl status bettermc4-server
#     sudo journalctl -u bettermc4-server -f
