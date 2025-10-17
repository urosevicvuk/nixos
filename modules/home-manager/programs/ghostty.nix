{ config, ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;
    enableZshIntegration = true;

    settings = {

      window-padding-x = 6;
      window-padding-y = 6;
      window-padding-color = "extend";

      confirm-close-surface = false;
    };
  };
}
