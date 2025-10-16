# Mako - minimal notification daemon
{ config, ... }:
let
  # Color scheme from stylix
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  red = "#${config.lib.stylix.colors.base08}";

  # Font configuration
  font = "${config.stylix.fonts.serif.name}";
  fontSize = config.stylix.fonts.sizes.desktop;

  # Theme variables
  inherit (config.theme) rounding border-size;
in
{
  # Disable stylix for mako
  stylix.targets.mako.enable = false;

  services.mako = {
    enable = true;

    # Appearance
    font = "${font} ${toString fontSize}";
    backgroundColor = background-alt;
    textColor = foreground;
    borderColor = accent;
    borderSize = border-size;
    borderRadius = rounding;

    # Layout
    width = 350;
    height = 150;
    margin = "10";
    padding = "15";

    # Position
    anchor = "top-right";

    # Behavior
    defaultTimeout = 5000;
    ignoreTimeout = false;

    # Grouping
    groupBy = "app-name";

    # Urgency levels
    extraConfig = ''
      [urgency=low]
      border-color=${accent}
      default-timeout=3000

      [urgency=normal]
      border-color=${accent}
      default-timeout=5000

      [urgency=critical]
      border-color=${red}
      default-timeout=0
      ignore-timeout=1
    '';
  };
}
