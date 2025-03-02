# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.xremap-flake.nixosModules.default
    ];
    
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;

  networking.hostName = "vukNixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #Style
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = {
	base00 = "282828"; # ----
	base01 = "3c3836"; # ---
	base02 = "504945"; # --
	base03 = "665c54"; # -
	base04 = "bdae93"; # +
	base05 = "d5c4a1"; # ++
	base06 = "ebdbb2"; # +++
	base07 = "fbf1c7"; # ++++
	base08 = "fb4934"; # red
	base09 = "fe8019"; # orange
	base0A = "fabd2f"; # yellow
	base0B = "b8bb26"; # green
	base0C = "8ec07c"; # aqua/cyan
	base0D = "83a598"; # blue
	base0E = "d3869b"; # purple
	base0F = "d65d0e"; # brown
	};

  stylix.image = ./wallp.jpg;

  stylix.cursor.package = pkgs.apple-cursor;
  stylix.cursor.name = "macOS";
  stylix.cursor.size = 24;

  stylix.fonts = {
	monospace = {
		package = pkgs.nerd-fonts.caskaydia-cove;
		name = "Caskaydia Cove";
	};
	sansSerif = {
		package = pkgs.meslo-lgs-nf;
		name = "MesloLGS NF Regular";
	};
	serif = {
		package = pkgs.meslo-lgs-nf;
		name = "MesloLGS NF Regular";
	};

  };

  stylix.polarity = "dark";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Remapping
  services.xremap = {
	withHypr = true;
	userName = "vuk23";

	yamlConfig = ''modmap:
  - name: CapsLock to RightCtrl/Esc
    remap:
      CapsLock:
        held: Ctrl_R
        alone: Esc
        alone_timeout: 500'';
  };


  #Gaming
  hardware.opengl = {
  	enable = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  #Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  #Bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vuk23 = {
    isNormalUser = true;
    description = "Vuk Urosevic";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager = 
  {
  	extraSpecialArgs = {inherit inputs; };
	users = 
	{
		"vuk23" = import ./home.nix;
	};
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "vuk23";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  #programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    FLAKE = "/home/vuk23/nixos";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	nh
	neovim
	git
	vesktop
	obsidian
	spotify
	(google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })
	home-manager
	fzf
	zsh
	kitty
	yazi
	btop
	tmux
	todoist
	gcc
	clang
	zig

	waybar
	dunst
	libnotify 
	hyprpaper
	ghostty
	rofi-wayland
  	
	lutris
	bottles
	protonup
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  environment.sessionVariables = {
  	STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/vuk23/.steam/root/compatibilitytools.d";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
