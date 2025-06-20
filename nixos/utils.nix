{ pkgs, config, ... }:
let
  hostname = config.var.hostname;
  keyboardLayout = config.var.keyboardLayout;
  keyboardVariant = config.var.keyboardVariant;
in {
  networking = {
    hostName = hostname;

    firewall = {
      allowedTCPPorts = [ 57621 8080 3306];
      allowedUDPPorts = [ 5353 ];
    };

  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = keyboardLayout;
        variant = keyboardVariant;
        options = "grp:alt_shift_toggle";
      };
      videoDrivers = [ "amdgpu" ];
    };
    gnome.gnome-keyring.enable = true;
    hardware.openrgb.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

  };
  console.keyMap = "us";

  environment.variables = {
    NH_FLAKE = "/home/vyke/.config/nixos";
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    PULSE_LATENCY_MSEC = 60;
  };

  services.libinput.enable = true;

  programs = {
    kdeconnect.enable = true;
    dconf.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
  };

  hardware = { graphics = { enable = true; }; };

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    teamviewer.enable = true;
  };

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
    ntfs3g
    openssh
    openrgb-with-all-plugins
  ];

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
