{ config, pkgs, ... }: {
  sops = {
    age.keyFile = "/home/${config.var.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      ssh-public-key = {
        owner = config.var.username;
        mode = "0644";
      };
      # Add additional secrets here as needed for server setup:
      # cloudflare-dns-token = { path = "/etc/cloudflare/dnskey.txt"; };
      # wireguard-config = { mode = "0600"; };
    };
  };

  environment.systemPackages = with pkgs; [ sops age ];
}
