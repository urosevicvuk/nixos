{ config, pkgs, ... }:
let
  inherit (config.var) username;
in
{
  virtualisation.docker.enable = true;

  users.users.${username}.extraGroups = [ "docker" ];

  home.packages = with pkgs; [
    lazydocker
  ];
}
