{ config, ... }:
{
  home.file.".ssh/allowed_signers".text = "* ${config.sops.secrets.github-pub.path}";
  programs.git.extraConfig = {
    commit.gpgsign = true;
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/id_ed25519.pub";
  };
}
