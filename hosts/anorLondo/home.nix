{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./variables.nix

    # Programs
    ../../modules/home-manager/programs/kitty
    ../../modules/home-manager/programs/ghostty
    ../../modules/home-manager/programs/nvf
    ../../modules/home-manager/programs/shell
    ../../modules/home-manager/programs/direnv
    ../../modules/home-manager/programs/fetch
    ../../modules/home-manager/programs/git
    ../../modules/home-manager/programs/spicetify
    ../../modules/home-manager/programs/thunar
    ../../modules/home-manager/programs/lazygit
    ../../modules/home-manager/programs/zen
    ../../modules/home-manager/programs/wofi
    ../../modules/home-manager/programs/zathura
    #../../modules/home/programs/tailscale #Server stuff
    #../../modules/home/programs/nextcloud #NAS stuff
    #../../modules/home/programs/anyrun # Sandbox stuff

    # Scripts
    ../../modules/home-manager/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../modules/home-manager/system/hyprland
    ../../modules/home-manager/system/hypridle
    ../../modules/home-manager/system/hyprlock
    ../../modules/home-manager/system/hyprpanel
    ../../modules/home-manager/system/hyprpaper
    ../../modules/home-manager/system/mime
    ../../modules/home-manager/system/udiskie
    ../../modules/home-manager/system/clipman

    ./secrets
  ];

  #All the programs that are not importes as modules
  programs = {
  };
  services = {
  };

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      google-chrome # Web browser
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

      #Gaming
      prismlauncher # Minecraft launcher
      #shadps4 # PS4 emulator
      lutris # Pirated game launcher
      (wineWowPackages.stable.override {waylandSupport = true;})
      winetricks
      protonup # Proton my beloved

      # Dev
      opencode
      claude-code
      go
      gh
      nodejs
      python3
      jq
      figlet
      just
      gnumake
      pnpm
      bruno
      bruno-cli
      lazydocker
      vscode
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      android-studio

      # Virtualization
      virt-manager
      virt-viewer

      #Office
      rustdesk
      libreoffice-qt6-fresh # Office suite

      # Utils
      nh # Nix helper
      qbittorrent
      p7zip
      ffmpeg
      optipng
      pfetch
      pandoc
      fastfetch
      nitch
      ripgrep
      yazi
      fzf
      btop-rocm
      dust
      jq
      bluez
      solaar
      piper
      moreutils
      vulkan-tools
      amdvlk

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
