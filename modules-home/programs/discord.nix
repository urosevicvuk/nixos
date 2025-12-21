# Discord is a popular chat application.
# Using Vesktop (Discord + Vencord) from nixpkgs for stability
{ pkgs, ... }:
{
  home.packages = [ pkgs.vesktop ];

  # Vesktop config is stored in ~/.config/vesktop/
  # Themes can be added manually via the Vencord interface
  # For declarative theming in the future, consider:
  # https://github.com/fufexan/dotfiles/tree/main/home/programs/discord
}
