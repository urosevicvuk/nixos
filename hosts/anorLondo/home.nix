{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./variables.nix

    # Programs
    ../../modules/home-manager/programs/btop
    ../../modules/home-manager/programs/direnv
    ../../modules/home-manager/programs/fetch
    ../../modules/home-manager/programs/git
    ../../modules/home-manager/programs/kitty
    ../../modules/home-manager/programs/nextcloud
    ../../modules/home-manager/programs/nvf
    ../../modules/home-manager/programs/shell
    ../../modules/home-manager/programs/spicetify
    ../../modules/home-manager/programs/thunar
    ../../modules/home-manager/programs/wofi
    ../../modules/home-manager/programs/zathura
    ../../modules/home-manager/programs/zen

    # Scripts
    ../../modules/home-manager/scripts # All scripts

    # System
    ../../modules/home-manager/system/clipman
    ../../modules/home-manager/system/hypridle
    ../../modules/home-manager/system/hyprland
    ../../modules/home-manager/system/hyprlock
    ../../modules/home-manager/system/hyprpanel
    ../../modules/home-manager/system/hyprpaper
    ../../modules/home-manager/system/mime
    ../../modules/home-manager/system/udiskie

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
        vesktop
        vlc
        obsidian
        libreoffice-qt

        #Drawing
        pinta
        figma-linux
        gimp3-with-plugins

        #Gaming
        lutris
        prismlauncher
        (wineWowPackages.stable.override { waylandSupport = true; })
        winetricks
        protonup
        protontricks
        shadps4

        # Dev
        opencode
        claude-code
        lazydocker
        gh
        nodejs
        just
        gnumake
        bruno
        vscode
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.rust-rover
        jetbrains.clion
        android-studio
        codeblocksFull
        jq

        # Utils
        nh
        nix-init
        ntfs3g
        qbittorrent
        p7zip
        ffmpeg
        optipng
        pfetch
        pandoc
        fastfetch
        nitch
        ripgrep
        fzf
        yazi
        jq
        bluez
        solaar
        piper
        curtail
        figlet
        moreutils
        vulkan-tools
        amdvlk
        freerdp

        # stevencodes recommendation
        oha
        hyperfine
        toxiproxy

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
