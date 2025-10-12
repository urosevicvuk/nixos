{ config, pkgs, ... }:
{
  # Cloudflare Tunnel (cloudflared)
  # Creates a secure tunnel from this server to Cloudflare
  # No public IP or port forwarding needed!

  # Using token-based setup (simpler than credentials file)
  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token $(cat ${config.sops.secrets.cloudflare-tunnel-token.path})";
      DynamicUser = true;
      LoadCredential = "token:${config.sops.secrets.cloudflare-tunnel-token.path}";
    };
  };

  environment.systemPackages = [ pkgs.cloudflared ];
}
