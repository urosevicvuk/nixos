{
  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      #installVimSyntax = true;
      settings = {
        window-padding-x = 6;
        window-padding-y = 6;

        confirm-close-surface = false;

        shell-integration = "zsh";
      };
    };
  };
}
