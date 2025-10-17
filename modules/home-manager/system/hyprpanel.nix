# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{ config, lib, ... }:
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

  programs.hyprpanel = {
    enable = true;
    #hyprland.enable = true;
    #overwrite.enable = true;
    #overlay.enable = true;

    settings = lib.mkForce {
      bar = {
        layouts = {
          "*" = {
            "left" = [
              "dashboard"
              "workspaces"
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
          monitorSpecific = true;
          applicationIconEmptyWorkspace = "";
          showApplicationIcons = true;
          showWsIcons = true;
          ignored = "^-(9.*)$";
        };
        clock.format = "%A, %d %B - %I:%M %p";
        windowtitle.label = true;
        volume.label = false;
        network.truncation_size = 12;
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

          outer_spacing = if floating && transparent then "0px" else "8px";

          buttons = {
            style = "default";
            monochrome = true;
            y_margins = if floating && transparent then "0px" else "8px";
            spacing = "0.3em";
            padding_x = "0.8rem";
            padding_y = "0.4rem";
            radius = (if transparent then toString rounding else toString (rounding - 8)) + "px";
            workspaces = {
              hover = accent-alt;
              active = accent;
              available = accent-alt;
              occupied = accent-alt;
            };
            text = if transparent && transparentButtons then foregroundOnWallpaper else foreground;
            background =
              (if transparent then background else background-alt) + (if transparentButtons then "00" else "");
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

            shadow = if transparent then "0 0 0 0" else "0px 0px 3px 1px #16161e";
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
          opacity = notificationOpacity;
          enableShadow = true;
          border_radius = toString rounding + "px";
          background = background-alt;
          actions.background = accent;
          actions.text = foreground;
          label = accent;
          border = background-alt;
          text = foreground;
          labelicon = accent;
          close_button.background = background-alt;
          close_button.label = "#f38ba8";
        };

        osd = {
          enable = true;
          orientation = "vertical";
          location = "left";
          radius = toString rounding + "px";
          margins = "0px 0px 0px 10px";
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
          location = location;
          unit = "metric";
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
