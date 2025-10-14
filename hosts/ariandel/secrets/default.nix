{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/${config.var.username}/.config/sops/age/keys.txt";

    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      anthropicKey = { };

      ssh-private = {
        path = "/home/${config.var.username}/.ssh/id_ed25519";
        mode = "0600";
      };

      ssh-public = {
        path = "/home/${config.var.username}/.ssh/id_ed25519.pub";
        mode = "0644";
      };

      cloudflare-dns-token = { };
      nextcloud-pwd = { };
    };

  };

  #home.file.".config/nixos/.sops.yaml".text = ''
  #  keys:
  #    - &primary age12yvtj49pfh3fqzqflscm0ek4yzrjhr6cqhn7x89gdxnlykq0xudq5c7334
  #  creation_rules:
  #    - path_regex: hosts/laptop/secrets/secrets.yaml$
  #      key_groups:
  #        - age:
  #          - *primary
  #    - path_regex: hosts/anorLondo/secrets/secrets.yaml$
  #      key_groups:
  #        - age:
  #          - *primary
  #    - path_regex: hosts/server/secrets/secrets.yaml$
  #      key_groups:
  #        - age:
  #          - *primary
  #'';

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  home.packages = with pkgs; [
    sops
    age
  ];

  wayland.windowManager.hyprland.settings.exec-once = [ "systemctl --user start sops-nix" ];
}
