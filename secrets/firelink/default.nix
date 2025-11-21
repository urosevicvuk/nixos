# Secrets specific to firelink (server)
{ config, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/home/${config.var.username}/.ssh/id_ed25519" ];
    defaultSopsFormat = "yaml";

    secrets = {
      # Cloudflare tokens
      "cloudflare-dns-token" = {
        sopsFile = ./cloudflare.yaml;
        key = "dns_token";
        owner = "acme";
        mode = "0400";
      };

      "cloudflare-tunnel-token" = {
        sopsFile = ./cloudflare.yaml;
        key = "tunnel_token";
        mode = "0400";
      };

      # Nextcloud
      "nextcloud-admin-password" = {
        sopsFile = ./nextcloud.yaml;
        key = "admin_password";
        owner = "nextcloud";
        mode = "0400";
      };

      # Disabled - placeholders only, uncomment when you add real values:
      # "hoarder-env" = {
      #   sopsFile = ./hoarder.yaml;
      #   key = "env_file";
      #   mode = "0400";
      # };
      #
      # "wireguard-pia" = {
      #   sopsFile = ./media.yaml;
      #   key = "wireguard_config";
      #   mode = "0400";
      # };
      #
      # "recyclarr-config" = {
      #   sopsFile = ./media.yaml;
      #   key = "recyclarr_config";
      #   mode = "0400";
      # };
    };
  };
}
