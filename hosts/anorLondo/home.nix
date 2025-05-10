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
      bitwarden # Password manager
      vlc # Video player
      obsidian # Note taking app
      planify # Todolists
      todoist # Todolists
      textpieces # Manipulate texts
      curtail # Compress images

      #Games
      prismlauncher
      torzu
      shadps4
      lutris
      (wineWowPackages.stable.override { waylandSupport = true; })
      winetricks
      protonup
      mangohud

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

      # Utils
      nh
      qbittorrent
      p7zip
      optipng
      pfetch
      pandoc
      btop-rocm
      fastfetch
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
