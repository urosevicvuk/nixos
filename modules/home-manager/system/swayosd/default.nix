# SwayOSD - on-screen display for volume/brightness
{ config, pkgs, ... }:
let
  # Color scheme from stylix
  accent = "#${config.lib.stylix.colors.base0D}";
  background-alt = "#${config.lib.stylix.colors.base01}";

  # Theme variables
  inherit (config.theme) rounding;
in
{
  # SwayOSD service
  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  # SwayOSD styling
  home.file.".config/swayosd/style.css".text = ''
    window {
      background-color: ${background-alt};
      border-radius: ${toString rounding}px;
      padding: 20px;
    }

    #container {
      margin: 10px;
    }

    progressbar trough {
      background-color: rgba(255, 255, 255, 0.1);
      border-radius: ${toString (rounding - 2)}px;
      min-height: 8px;
    }

    progressbar progress {
      background-color: ${accent};
      border-radius: ${toString (rounding - 2)}px;
      min-height: 8px;
    }

    image {
      color: ${accent};
      margin-right: 10px;
    }

    label {
      color: ${accent};
      font-size: 18px;
      font-weight: bold;
      margin-left: 10px;
    }
  '';
}
