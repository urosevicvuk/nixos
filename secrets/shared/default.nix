# Shared home-manager secrets available on all hosts
# This module manages user-level secrets and the .sops.yaml configuration
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
      - path_regex: secrets/(firelink|server)/.*\.yaml$
        key_groups:
          - age:
              - age18nfkzf6c32fnysaeuh64ryqj5dhm8j5f84rl50dc6yuevl87v9esn7nzqu
  '';

  # Add sops and age to user packages (home-manager)
  home.packages = with pkgs; [
    sops
    age
    ssh-to-age
  ];

  # Automatically generate age key from SSH key for manual sops editing
  home.activation.setupSopsAge = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f /home/${config.var.username}/.ssh/id_ed25519 ]; then
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG /home/${config.var.username}/.config/sops/age
      $DRY_RUN_CMD ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /home/${config.var.username}/.ssh/id_ed25519 > /home/${config.var.username}/.config/sops/age/keys.txt
      $DRY_RUN_CMD chmod $VERBOSE_ARG 600 /home/${config.var.username}/.config/sops/age/keys.txt
    fi
  '';

  # Home-manager sops configuration (user-level secrets)
  sops = {
    age.sshKeyPaths = [ "/home/${config.var.username}/.ssh/id_ed25519" ];
    defaultSopsFormat = "yaml";

    secrets = {
      # Anthropic API key (for Claude Code)
      "anthropic-api-key" = {
        sopsFile = ./anthropic.yaml;
        key = "api_key";
        mode = "0400";
      };

      # SSH keys - DISABLED: Manage SSH keys manually instead of via sops
      # This prevents the chicken-and-egg problem where sops needs SSH keys to decrypt,
      # but SSH keys are managed by sops
      # "ssh-private" = {
      #   sopsFile = ./ssh-keys.yaml;
      #   key = "private";
      #   path = "/home/${config.var.username}/.ssh/id_ed25519";
      #   mode = "0600";
      # };

      # "ssh-public" = {
      #   sopsFile = ./ssh-keys.yaml;
      #   key = "public";
      #   path = "/home/${config.var.username}/.ssh/id_ed25519.pub";
      #   mode = "0644";
      # };
    };
  };
}
