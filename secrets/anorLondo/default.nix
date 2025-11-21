# Secrets specific to anorLondo (desktop)
{ config, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/home/${config.var.username}/.ssh/id_ed25519" ];
    defaultSopsFormat = "yaml";

    secrets = {
      # No host-specific secrets yet
      # Add them as needed
    };
  };
}
