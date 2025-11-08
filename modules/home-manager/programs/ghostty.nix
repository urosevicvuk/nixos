{ config, ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;
    enableZshIntegration = true;

    settings = {
      # Use Nerd Font for monochrome glyphs instead of colored emoji
      font-family = [
        config.stylix.fonts.monospace.name
        "Symbols Nerd Font Mono"
      ];
      font-size = config.stylix.fonts.sizes.terminal;

      window-padding-x = 6;
      window-padding-y = 6;
      #window-padding-color = "extend";

      confirm-close-surface = false;
    };
  };
}
