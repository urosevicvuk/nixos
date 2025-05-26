{ pkgs, config, ... }: {

  imports = [
    ./variables.nix

    # Programs
    ../../home/programs/kitty
    ../../home/programs/nvim
    # ../../home/programs/nvf
    # ../../home/programs/qutebrowser
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/ghostty
    ../../home/programs/spicetify
    ../../home/programs/nextcloud
    ../../home/programs/thunar
    ../../home/programs/lazygit
    ../../home/programs/zen
    ../../home/programs/duckduckgo-colorscheme

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hypridle
    ../../home/system/hyprlock
    ../../home/system/hyprpanel
    ../../home/system/hyprpaper
    ../../home/system/wofi
    ../../home/system/batsignal
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    ../../home/system/clipman

    #./secrets # You should probably remove this line, this is where I store my secrets
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      discord # Chat
      vesktop # Discord client
      bitwarden # Password manager
      vlc # Video player
      obsidian # Note taking app
      planify # Todolists
      todoist # Todolists
      textpieces # Manipulate texts
      curtail # Compress images
      gimp3-with-plugins

      #Gaming
      prismlauncher # Minecraft launcher
      shadps4 # PS4 emulator
      lutris # Pirated game launcher
      (wineWowPackages.stable.override { waylandSupport = true; })
      winetricks
      protonup # Proton my beloved
      mangohud # FPS counter
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav

      # Dev
      go
      nodejs
      python3
      jq
      figlet
      just
      pnpm
      lazydocker
      vscode
      jetbrains-toolbox
      insomnia

      # Utils
      nh # Nix helper
      qbittorrent
      p7zip
      optipng
      pfetch
      pandoc
      btop-rocm
      fastfetch
      nitch
      ripgrep
      yazi
      fzf
      bluez
      solaar

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      firefox
      vscode
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = { source = ./profile_picture.png; };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
