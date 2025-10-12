{ config, lib, ... }:
{
  # Cloudflare Tunnel (cloudflared)
  # Creates a secure tunnel from this server to Cloudflare
  # No public IP or port forwarding needed!

  services.cloudflared = {
    enable = true;
    tunnels = {
      # Tunnel name - will be set up via Cloudflare dashboard
      "urosevicvuk-tunnel" = {
        credentialsFile = config.sops.secrets.cloudflare-tunnel-credentials.path;
        default = "http_status:404";

        ingress = {
          # Route cloud.urosevicvuk.dev to Nextcloud
          "cloud.urosevicvuk.dev" = "http://localhost:80";

          # Add more services here as needed:
          # "example.urosevicvuk.dev" = "http://localhost:8080";
        };
      };
    };
  };

  # Don't need public firewall ports with tunnel
  # networking.firewall.allowedTCPPorts = lib.mkForce [ ];
}
