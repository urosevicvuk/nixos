{
  pkgs,
  ...
}:
{

  sops = {
    age.keyFile = "/home/vyke/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      # Cloudflare DNS API token for ACME SSL certificates
      cloudflare-dns-token = {
        mode = "0400";
      };

      # Cloudflare Tunnel token
      cloudflare-tunnel-token = {
        mode = "0400";
      };

      # Nextcloud admin password
      nextcloud-pwd = {
        owner = "nextcloud";
        mode = "0400";
      };

      # SSH keys
      ssh-private = {
        owner = "vyke";
        mode = "0600";
        path = "/home/vyke/.ssh/id_ed25519";
      };

      ssh-public = {
        owner = "vyke";
        mode = "0644";
        path = "/home/vyke/.ssh/id_ed25519.pub";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
