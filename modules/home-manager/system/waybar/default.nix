# Waybar - minimal top bar
{ config, lib, pkgs, ... }:
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
  inherit (config.theme) rounding;
  inherit (config.theme.bar) position;

  # Device detection
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  # Disable stylix for waybar
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = position;
        spacing = 0;
        height = 26;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
        ] ++ lib.optionals isLaptop [ "battery" ];

        # Workspaces module
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            empty = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # Clock module
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y - %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${foreground}'><b>{}</b></span>";
              days = "<span color='${foreground}'>{}</span>";
              weeks = "<span color='${accent}'><b>W{}</b></span>";
              weekdays = "<span color='${accent}'><b>{}</b></span>";
              today = "<span color='${accent}'><b><u>{}</u></b></span>";
            };
          };
        };

        # System tray
        tray = {
          spacing = 10;
        };

        # Bluetooth
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        # Network
        network = {
          format-wifi = "󰖩";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) 󰖩";
          tooltip-format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        # PulseAudio
        pulseaudio = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          tooltip-format = "{volume}%";
          on-click = "pavucontrol";
        };

        # CPU
        cpu = {
          format = "󰻠";
          tooltip-format = "CPU: {usage}%";
          interval = 2;
        };

        # Battery (laptop only)
        battery = lib.mkIf isLaptop {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "󰂄";
          format-plugged = "󰚥";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{capacity}% {timeTo}";
        };
      };
    };

    style = ''
      * {
        background-color: ${background};
        color: ${foreground};

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: ${font};
        font-size: ${toString fontSize}px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
        color: ${foreground};
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.active {
        color: ${accent};
      }

      #tray,
      #cpu,
      #battery,
      #network,
      #bluetooth,
      #pulseaudio {
        min-width: 12px;
        margin: 0 7.5px;
      }

      tooltip {
        padding: 2px;
        background-color: ${background-alt};
        border: 1px solid ${accent};
        border-radius: ${toString rounding}px;
      }

      #clock {
        margin-left: 8.75px;
      }

      #battery.warning {
        color: ${red};
      }

      #battery.critical {
        color: ${red};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          opacity: 0.5;
        }
      }
    '';
  };
}
