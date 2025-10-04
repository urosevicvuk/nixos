{ pkgs, config, ... }:
let
  inherit (config.var) username;
in
{
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      #ssh = {
      #  owner = "${username}";
      #  path = "/home/${username}/.ssh/config";
      #  mode = "0600";
      #};
      #github-key = {
      #  owner = "${username}";
      #  path = "/home/${username}/.ssh/github";
      #  mode = "0600";
      #};
      #signing-key = {
      #  owner = "${username}";
      #  path = "/home/${username}/.ssh/key";
      #  mode = "0600";
      #};
      #signing-pub-key = {
      #  owner = "${username}";
      #  path = "/home/${username}/.ssh/key.pub";
      #  mode = "0600";
      #};
      #cloudflare-dns-token = { path = "/etc/cloudflare/dnskey.txt"; };
      #nextcloud-pwd = { path = "/etc/nextcloud/pwd.txt"; };
      #adguard-pwd = { };
      #hoarder = { };
      #recyclarr = {
      #  owner = "recyclarr";
      #  mode = "0777";
      #};
      #wireguard-pia = {
      #  # owner = "media";
      #  group = "media";
      #  mode = "0600";
      #};
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
