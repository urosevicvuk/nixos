{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./variables.nix

    # Programs
    ../../modules/home-manager/programs/btop.nix
    ../../modules/home-manager/programs/direnv.nix
    ../../modules/home-manager/programs/discord.nix
    ../../modules/home-manager/programs/editorconfig.nix
    ../../modules/home-manager/programs/ghostty.nix
    ../../modules/home-manager/programs/fetch
    ../../modules/home-manager/programs/git.nix
    ../../modules/home-manager/programs/kitty.nix
    ../../modules/home-manager/programs/nextcloud.nix
    ../../modules/home-manager/programs/nvf
    ../../modules/home-manager/programs/obs-studio.nix
    ../../modules/home-manager/programs/shell
    ../../modules/home-manager/programs/spicetify.nix
    ../../modules/home-manager/programs/thunar.nix
    ../../modules/home-manager/programs/walker.nix
    ../../modules/home-manager/programs/wofi.nix
    ../../modules/home-manager/programs/zathura.nix
    ../../modules/home-manager/programs/zen.nix

    # Scripts
    ../../modules/home-manager/scripts # All scripts

    # System
    ../../modules/home-manager/system/clipman.nix
    ../../modules/home-manager/system/hypridle.nix
    ../../modules/home-manager/system/hyprland
    ../../modules/home-manager/system/hyprlock.nix
    ../../modules/home-manager/system/hyprpanel.nix
    ../../modules/home-manager/system/hyprpaper.nix
    ../../modules/home-manager/system/mime.nix
    ../../modules/home-manager/system/udiskie.nix

    #../../modules/home-manager/system/waybar.nix
    #../../modules/home-manager/system/mako.nix
    #../../modules/home-manager/system/swayosd.nix

    ./secrets
  ];

  #All the programs that are not importes as modules
  programs = {
  };
  services = {
  };

  # Overlays
  #nixpkgs.overlays = [
  #  (final: prev: {

  #  })
  #];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages =
      (with pkgs; [
        # Apps
        obsidian
        vlc
        libreoffice-fresh
        figma-linux
        gimp3-with-plugins
        pinta
        qbittorrent

        # Affinity
        inputs.affinity-nix.packages.x86_64-linux.v3

        # Dev
        pnpm
        nodejs
        claude-code
        opencode
        gh
        gnumake
        postman
        bruno
        vscode
        rstudioWrapper
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.rust-rover
        jetbrains.clion
        android-studio

        # Utils
        nh
        nix-init
        ntfs3g
        p7zip
        ffmpeg
        optipng
        bluez
        curtail
        moreutils
        vulkan-tools

        # Laptop utilities
        acpi
        powertop
        figlet

        # TUI system managers
        bluetuith # Bluetooth manager
        wiremix # PipeWire audio mixer
        # nmtui is built-in with NetworkManager (no need to install)

        # Virtualization
        freerdp

        # Just cool
        peaclock
        cbonsai
        pipes
        cmatrix
        neo-cowsay

      ])
      ++ (with pkgs.stable; [
        # Stable packages (25.05)
      ]);

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
