# Shared secrets available on all hosts
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  # Declaratively manage .sops.yaml (home-manager)
  home.file."${config.var.configDirectory}/.sops.yaml".text = ''
    creation_rules:
      - path_regex: secrets/shared/.*\.yaml$
        key_groups:
          - age:
              - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
      - path_regex: secrets/ariandel/.*\.yaml$
        key_groups:
          - age:
              - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
      - path_regex: secrets/anorLondo/.*\.yaml$
        key_groups:
          - age:
              - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
      - path_regex: secrets/firelink/.*\.yaml$
        key_groups:
          - age:
              - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
  '';

  # Add sops and age to user packages (home-manager)
  home.packages = with pkgs; [
    sops
    age
  ];

  # Sops secrets configuration (NixOS)
  sops = {
    # Use SSH keys instead of age
    age.sshKeyPaths = [ "/home/${config.var.username}/.ssh/id_ed25519" ];
    defaultSopsFormat = "yaml";

    secrets = {
      # Anthropic API key (for Claude Code)
      "anthropic-api-key" = {
        sopsFile = ./anthropic.yaml;
        key = "api_key";
        #owner = config.var.username;
        mode = "0400";
      };

      # SSH keys
      "ssh-private" = {
        sopsFile = ./ssh-keys.yaml;
        key = "private";
        path = "/home/${config.var.username}/.ssh/id_ed25519";
        #owner = config.var.username;
        mode = "0600";
      };

      "ssh-public" = {
        sopsFile = ./ssh-keys.yaml;
        key = "public";
        path = "/home/${config.var.username}/.ssh/id_ed25519.pub";
        #owner = config.var.username;
        mode = "0644";
      };
    };
  };
}
