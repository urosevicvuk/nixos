# Discord is a popular chat application.
{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  stylix.targets.nixcord.enable = false;

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;

    config = {
      frameless = true;

      themeLinks = [
        "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
      ];
    };
  };
}
