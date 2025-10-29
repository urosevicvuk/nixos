# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{
  config,
  lib,
  pkgs,
  ...
}:
let

  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  foregroundOnWallpaper = "#${config.theme.textColorOnWallpaper}";
  font = "${config.stylix.fonts.serif.name}";
  fontSizeForHyprpanel = "${toString config.stylix.fonts.sizes.desktop}px";

  inherit (config.theme) rounding;
  inherit (config.theme) border-size;
  inherit (config.theme) gaps-out;
  inherit (config.theme) gaps-in;

  inherit (config.theme.bar) floating;
  inherit (config.theme.bar) transparent;
  inherit (config.theme.bar) position;
  inherit (config.theme.bar) transparentButtons;

  inherit (config.var) location;
  inherit (config.var) device;

  isLaptop = device == "laptop";
  notificationOpacity = 90;
in
{
  #imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  # exec-once moved to main hyprland config to avoid conflicts

  # Custom modules configuration file
  home.file.".config/hyprpanel/modules.json".text = builtins.toJSON {
    "custom/recording" = {
      icon = {
        idle = "";
        recording = "⏺";
      };
      label = "";
      tooltip = "{tooltip}";
      execute = ''if [ -f /tmp/recording-indicator ]; then echo '{"alt": "recording", "tooltip": "Recording - Click to stop"}'; else echo '{"alt": "idle", "tooltip": "Not recording"}'; fi'';
      interval = 2000;
      hideOnEmpty = true;
      actions = {
        onLeftClick = "record-screen";
      };
    };

    "custom/caffeine" = {
      icon = {
        active = "󰅶";
        inactive = "";
      };
      label = "";
      tooltip = "{tooltip}";
      execute = ''if ! pgrep -x hypridle >/dev/null 2>&1; then echo '{"alt": "active", "tooltip": "Caffeine active - Click to disable"}'; else echo '{"alt": "inactive", "tooltip": "Idle lock enabled"}'; fi'';
      interval = 2000;
      hideOnEmpty = true;
      actions = {
        onLeftClick = "caffeine";
      };
    };

    "custom/nightshift" = {
      icon = {
        active = "󰖔";
        inactive = "";
      };
      label = "";
      tooltip = "{tooltip}";
      execute = ''if pgrep -x hyprsunset >/dev/null 2>&1; then echo '{"alt": "active", "tooltip": "Night shift enabled - Click to disable"}'; else echo '{"alt": "inactive", "tooltip": "Night shift disabled"}'; fi'';
      interval = 2000;
      hideOnEmpty = true;
      actions = {
        onLeftClick = "night-shift";
      };
    };

    # COMMENTED: VPN indicator (for future use)
    # "custom/vpn" = {
    #   icon = {
    #     connected = "󰖂";
    #     disconnected = "";
    #   };
    #   execute = ''if pgrep -f openvpn >/dev/null 2>&1; then echo '{"alt": "connected"}'; else echo '{"alt": "disconnected"}'; fi'';
    #   interval = 5000;
    #   hideOnEmpty = true;
    #   actions = {
    #     onLeftClick = "openvpn-toggle";
    #   };
    # };

    # COMMENTED: Docker indicator (for future use)
    # "custom/docker" = {
    #   icon = "🐳";
    #   label = "Docker";
    #   execute = ''docker ps -q 2>/dev/null | wc -l'';
    #   interval = 10000;
    #   hideOnEmpty = true;
    # };
  };

  programs.hyprpanel = {
    enable = true;
    #hyprland.enable = true;
    #overwrite.enable = true;
    #overlay.enable = true;

    settings = lib.mkForce {
      scalingPriority = "hyprland";

      bar = {
        layouts = {
          "*" = {
            "left" = [
              "dashboard"
              "workspaces"
              #"custom/recording"    # Recording indicator (hidden when not recording)
              #"custom/caffeine"     # Caffeine indicator (hidden when idle enabled)
              #"custom/nightshift"   # Night shift indicator (hidden when off)
            ];
            "middle" = [ "clock" ];
            "right" = [
              "systray"
              "volume"
              "bluetooth"
              "network"
              "kbinput"
            ]
            ++ lib.optionals isLaptop [
              "battery"
            ]
            ++ [
              "notifications"
            ];
          };
        };

        launcher.icon = "";
        workspaces = {
          show_numbered = false;
          workspaces = 11;
          numbered_active_indicator = "color";
          monitorSpecific = false;
          applicationIconEmptyWorkspace = "";
          showApplicationIcons = true;
          showWsIcons = true;
          ignored = "^-(9.*)$";
        };
        clock = {
          format = "%A, %d %B - %I:%M %p ";
          icon.enable = false;
        };
        windowtitle.label = true;
        volume.label = false;
        network.truncation_size = 99;
        bluetooth.label = false;
        notifications.show_total = false;
        media.show_active_only = true;
      };

      theme = {
        font = {
          name = font;
          size = fontSizeForHyprpanel;
        };

        bar = {

          outer_spacing = "0px";

          buttons = {
            style = "default";
            monochrome = true;
            y_margins = "0px";
            spacing = "0.3em";
            padding_x = "0.8rem";
            padding_y = "0.4rem";
            radius = rounding;
            workspaces = {
              hover = accent-alt;
              active = accent;
              available = accent-alt;
              occupied = accent-alt;
            };
            text = foreground;
            background = background + (if transparentButtons then "00" else "");
            icon = accent;
            hover = background;
            notifications = {
              background = background-alt;
              hover = background;
              total = accent;
              icon = accent;
            };
          };

          floating = floating;
          margin_top = (if position == "top" then toString (gaps-in * 2) else "0") + "px";
          margin_bottom = (if position == "top" then "0" else toString (gaps-in * 2)) + "px";
          margin_sides = toString gaps-out + "px";
          border_radius = toString rounding + "px";
          transparent = transparent;
          location = position;
          dropdownGap = "4.5em";
          background = background + (if transparentButtons && transparent then "00" else "");

          menus = {

            shadow = "0 0 0 0";
            monochrome = true;
            card_radius = toString rounding + "px";
            border = {
              size = toString border-size + "px";
              radius = toString rounding + "px";
              color = accent;
            };
            menu.media = {
              background.color = background-alt;
              card = {
                tint = 90;
                color = background-alt;
              };
            };
            background = background;
            cards = background-alt;
            label = foreground;
            text = foreground;
            popover.text = foreground;
            popover.background = background-alt;
            listitems.active = accent;
            icons.active = accent;
            switch.enabled = accent;
            check_radio_button.active = accent;
            buttons.default = accent;
            buttons.active = accent;
            iconbuttons.active = accent;
            progressbar.foreground = accent;
            slider.primary = accent;
            tooltip.background = background-alt;
            tooltip.text = foreground;
            dropdownmenu.background = background-alt;
            dropdownmenu.text = foreground;
          };
        };

        notification = {
          opacity = 100;

          # Use shadow for positioning offset (shadow hack)
          enableShadow = true;
          shadow = "0px 0px 0px 0px";
          shadowMargins = "12px 12px";

          border_radius = toString rounding + "px";

          # Single solid background color
          background = background-alt;

          # Colored border for accent
          border = accent;

          # Text colors
          text = foreground;
          label = foreground;
          labelicon = foreground;

          # Action buttons (shown on hover due to showActionsOnHover)
          actions.background = background;
          actions.text = foreground;

          # Hide close button
          close_button.background = "transparent";
          close_button.label = "transparent";
        };

        osd = {
          enable = true;
          orientation = "horizontal";
          location = "bottom";
          radius = toString rounding + "px";
          margins = "0px 0px 20px 0px";
          muted_zero = true;

          bar_color = accent;
          bar_overflow_color = accent-alt;
          icon = background;
          icon_container = accent;
          label = accent;
          bar_container = background-alt;
        };

      };

      notifications = {
        position = "top right";
        showActionsOnHover = true;
      };

      menus = {

        clock.weather = {
          enabled = false;
        };

        dashboard = {
          powermenu = {
            confirmation = false;
            avatar.image = "~/.face.icon";
          };
          shortcuts = {
            left = {
              shortcut1 = {
                icon = "";
                command = "zen";
                tooltip = "Zen";
              };
              shortcut2 = {
                icon = "󰅶";
                command = "caffeine";
                tooltip = "Caffeine";
              };
              shortcut3 = {
                icon = "󰖔";
                command = "night-shift";
                tooltip = "Night-shift";
              };
              shortcut4 = {
                icon = "";
                command = "menu";
                tooltip = "Search Apps";
              };
            };
            right = {
              shortcut1 = {
                icon = "";
                command = "hyprpicker -a";
                tooltip = "Color Picker";
              };
              shortcut3 = {
                icon = "󰄀";
                command = "screenshot region swappy";
                tooltip = "Screenshot";
              };
            };
          };
        };

        power.lowBatteryNotification = true;
      };

      wallpaper.enable = false;

      #Set for update fix, when it becomes a package, this should be back to override
    };

  };
}
