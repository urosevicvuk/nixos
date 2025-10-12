{ pkgs, config, ... }:
let
  inherit (config.var) hostname;
  inherit (config.var) keyboardLayout;
  inherit (config.var) configDirectory;
  inherit (config.var) timeZone;
  inherit (config.var) defaultLocale;
  inherit (config.var) extraLocale;
  inherit (config.var) autoUpgrade;
  inherit (config.var) keyboardVariant;
in
{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  system.autoUpgrade = {
    enable = autoUpgrade;
    dates = "04:00";
    flake = "${configDirectory}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    allowReboot = false;
  };

  time = {
    inherit timeZone;
  };

  i18n.defaultLocale = defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = extraLocale;
    LC_IDENTIFICATION = extraLocale;
    LC_MEASUREMENT = extraLocale;
    LC_MONETARY = extraLocale;
    LC_NAME = extraLocale;
    LC_NUMERIC = extraLocale;
    LC_PAPER = extraLocale;
    LC_TELEPHONE = extraLocale;
    LC_TIME = extraLocale;
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = keyboardLayout;
        variant = keyboardVariant;
        options = "grp:alt_shift_toggle";
      };
    };
    gnome.gnome-keyring.enable = true;
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
  console.keyMap = "us";

  hardware.graphics.enable = true;

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    NH_FLAKE = "/home/vyke/.config/nixos";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    TERM = "kitty";
    BROWSER = "zen-beta";
    PULSE_LATENCY_MSEC = 60;
  };

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    libinput.enable = true;
  };

  programs = {
    dconf.enable = true;
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  # Faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  environment.systemPackages = with pkgs; [
    hyprland-qtutils
    fd
    bc
    gcc
    git-ignore
    xdg-utils
    wget
    curl
    vim
    nixfmt-rfc-style
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";

    # userland niceness
    rtkit.enable = true;

    # don't ask for password for wheel group
    sudo.wheelNeedsPassword = false;
  };

}
