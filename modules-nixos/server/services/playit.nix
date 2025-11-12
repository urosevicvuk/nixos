{ config, pkgs, lib, ... }:

let
  # Fetch the playit.gg agent binary
  playit = pkgs.stdenv.mkDerivation rec {
    pname = "playit";
    version = "0.15.26";

    src = pkgs.fetchurl {
      url = "https://github.com/playit-cloud/playit-agent/releases/download/v${version}/playit-linux-amd64";
      sha256 = "0pc6v7mdj454i81cqzbbdhcj8pl262kxxlvlpyrsdn5zgy9h4zyv";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/playit
      chmod +x $out/bin/playit
    '';
  };
in
{
  # Playit.gg Tunnel Service
  # Provides tunneling for game servers (better than Cloudflare for TCP/UDP)

  systemd.services.playit = {
    description = "Playit.gg Tunnel Agent";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      ExecStart = "${playit}/bin/playit start";
      WorkingDirectory = "/var/lib/playit";
      StateDirectory = "playit";

      # Security hardening
      User = "playit";
      Group = "playit";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/playit" "/etc/playit" ];
    };
  };

  # Create playit user
  users.users.playit = {
    isSystemUser = true;
    group = "playit";
    description = "Playit.gg tunnel service user";
  };

  users.groups.playit = {};

  environment.systemPackages = [ playit ];
}

# SETUP INSTRUCTIONS:
#
# 1. First deployment will fail due to hash. Get the correct hash:
#    nix-prefetch-url https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64
#
# 2. Replace the sha256 hash above with the output
#
# 3. Rebuild and deploy:
#    sudo nixos-rebuild switch
#
# 4. Set up the tunnel (one-time):
#    sudo -u playit playit setup
#    # Follow the instructions to link your account
#
# 5. Add tunnels via playit.gg dashboard:
#    - RLCraft: TCP port 25566
#    - ekittens: TCP port 25565
#
# 6. Check status:
#    sudo systemctl status playit
#    sudo journalctl -u playit -f
