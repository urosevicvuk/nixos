# Discord is a popular chat application.
{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    config = {
      frameless = true;

      themeLinks = [
        "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
      ];
    };
  };
}
