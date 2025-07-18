{ pkgs, config, ... }:
let
  username = config.var.username;
  hostname = config.var.hostname;
  keyboardLayout = config.var.keyboardLayout;
  configDir = config.var.configDirectory;
  timeZone = config.var.timeZone;
  defaultLocale = config.var.defaultLocale;
  extraLocale = config.var.extraLocale;
  autoUpgrade = config.var.autoUpgrade;
  keyboardVariant = config.var.keyboardVariant;
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
    flake = "${configDir}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    allowReboot = false;
  };

  time = {
    timeZone = timeZone;
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

  users.users.${username}.extraGroups = [ "inputs" ];

  services = {
    ratbagd.enable = true;
    udev = {
      packages = [ pkgs.solaar ];
      extraRules = ''
        # Allow access to the Solaar device
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0664", GROUP="input"
        SUBSYSTEM=="hidraw", KERNELS=="*046D*", MODE="0664", GROUP="input"
      '';
    };
    xserver = {
      enable = true;
      xkb = {
        layout = keyboardLayout;
        variant = keyboardVariant;
        options = "grp:alt_shift_toggle";
      };
    };
    gnome.gnome-keyring.enable = true;
    hardware.openrgb.enable = true;
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
  console.keyMap = "us";

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
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
  programs = {
    kdeconnect.enable = true;
    dconf.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
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

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
