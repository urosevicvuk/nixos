{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./variables.nix

    # Programs
    ../../modules/home/programs/kitty
    ../../modules/home/programs/nvf
    ../../modules/home/programs/shell
    ../../modules/home/programs/fetch
    ../../modules/home/programs/git
    ../../modules/home/programs/git/signing.nix
    ../../modules/home/programs/spicetify
    ../../modules/home/programs/thunar
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/zen
    ../../modules/home/programs/discord
    #../../modules/home/programs/nixvim #Currently using nvf so no need for this
    #../../modules/home/programs/tailscale #Server stuff
    #../../modules/home/programs/nextcloud #NAS stuff
    #../../modules/home/programs/anyrun # Sandbox stuff

    # Scripts
    ../../modules/home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../modules/home/system/hyprland
    ../../modules/home/system/hypridle
    ../../modules/home/system/hyprlock
    ../../modules/home/system/hyprpanel
    ../../modules/home/system/hyprpaper
    ../../modules/home/system/wofi
    ../../modules/home/system/zathura
    ../../modules/home/system/mime
    ../../modules/home/system/udiskie
    ../../modules/home/system/clipman
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      vesktop # Discord client
      bitwarden # Password manager
      vlc # Video player
      obsidian # Note taking app
      todoist-electron # Todolists
      textpieces # Manipulate texts
      curtail # Compress images
      gimp3-with-plugins
      gnome-clocks
      gnome-text-editor
      figma-linux
      libreoffice-qt6-fresh # Office suite

      #Gaming
      prismlauncher # Minecraft launcher
      shadps4 # PS4 emulator
      lutris # Pirated game launcher
      (wineWowPackages.stable.override { waylandSupport = true; })
      winetricks
      protonup # Proton my beloved

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

      #Office
      rustdesk

      # Utils
      nh # Nix helper
      qbittorrent
      p7zip
      optipng
      pfetch
      pandoc
      fastfetch
      nitch
      ripgrep
      yazi
      fzf
      bluez
      solaar
      btop-rocm

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
