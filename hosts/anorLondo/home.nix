{
  pkgs,
  config,
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
        vlc
        obsidian
        libreoffice-qt

        #Drawing
        pinta
        figma-linux
        gimp3-with-plugins

        # Dev
        claude-code
        gh
        nodejs
        gnumake
        bruno
        vscode
        rstudioWrapper
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.rust-rover
        jetbrains.clion
        android-studio
        codeblocksFull

        # Utils
        nh
        nix-init
        ntfs3g
        qbittorrent
        p7zip
        ffmpeg
        optipng
        bluez
        curtail
        figlet
        moreutils
        vulkan-tools
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
