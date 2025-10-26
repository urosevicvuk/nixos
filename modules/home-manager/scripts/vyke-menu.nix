# vyke-menu - Main unified menu system
# Declarative NixOS version of Omarchy menu concept
{ pkgs, config, ... }:
let
  terminal = config.var.terminal;
  
  # Main menu entry point
  vyke-menu = pkgs.writeShellScriptBin "vyke-menu" ''
    show_main_menu() {
      options=(
        "󰀻  Apps"
        "󰧑  Learn"
        "󱓞  Actions"
        "  Config"
        "  Scripts"
        "  System"
      )
      
      selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
      
      case "$selected" in
        *Apps*)
          ${pkgs.walker}/bin/walker
          ;;
        *Learn*)
          show-keybindings
          ;;
        *Actions*)
          vyke-menu-actions
          ;;
        *Config*)
          vyke-menu-config
          ;;
        *Scripts*)
          vyke-menu-scripts
          ;;
        *System*)
          powermenu
          ;;
      esac
    }
    
    show_main_menu
  '';
  
  # Actions submenu (Capture, Toggle, Share)
  vyke-menu-actions = pkgs.writeShellScriptBin "vyke-menu-actions" ''
    options=(
      "  Capture"
      "󰔎  Toggle"
      "  Share"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *Capture*)
        vyke-menu-capture
        ;;
      *Toggle*)
        vyke-menu-toggle
        ;;
      *Share*)
        vyke-menu-share
        ;;
    esac
  '';
  
  # Capture submenu (Screenshot, Recording, Color Picker)
  vyke-menu-capture = pkgs.writeShellScriptBin "vyke-menu-capture" ''
    options=(
      "  Screenshot - Smart"
      "  Screenshot - Region"
      "  Screenshot - Window"
      "  Screenshot - Monitor"
      "⏺  Screen Record"
      "⏹  Stop Recording"
      "󰃉  Color Picker"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Smart"*)
        smart-screenshot
        ;;
      *"Region"*)
        screenshot region swappy
        ;;
      *"Window"*)
        screenshot window swappy
        ;;
      *"Monitor"*)
        screenshot monitor swappy
        ;;
      *"Screen Record"*)
        record-screen
        ;;
      *"Stop Recording"*)
        pkill -INT wf-recorder
        ;;
      *"Color Picker"*)
        ${pkgs.hyprpicker}/bin/hyprpicker -a
        ;;
    esac
  '';
  
  # Toggle submenu (Caffeine, Night Shift, Idle, etc.)
  vyke-menu-toggle = pkgs.writeShellScriptBin "vyke-menu-toggle" ''
    # Get current states
    caffeine_icon=$(caffeine-status-icon)
    nightshift_icon=$(night-shift-status-icon)
    idle_status=$(systemctl --user is-active hypridle >/dev/null 2>&1 && echo "󱫖" || echo "󱫖")
    panel_status=$(pgrep hyprpanel >/dev/null && echo "" || echo "")
    
    options=(
      "$caffeine_icon  Caffeine"
      "$nightshift_icon  Night Shift"
      "$idle_status  Idle Lock"
      "$panel_status  Status Bar"
      "󰍜  Waybar"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *Caffeine*)
        caffeine
        ;;
      *"Night Shift"*)
        night-shift
        ;;
      *"Idle Lock"*)
        if systemctl --user is-active hypridle >/dev/null 2>&1; then
          systemctl --user stop hypridle
          ${pkgs.libnotify}/bin/notify-send "Idle Lock Disabled"
        else
          systemctl --user start hypridle
          ${pkgs.libnotify}/bin/notify-send "Idle Lock Enabled"
        fi
        ;;
      *"Status Bar"*)
        hyprpanel-toggle
        ;;
      *Waybar*)
        pkill waybar || waybar &
        ;;
    esac
  '';
  
  # Share submenu
  vyke-menu-share = pkgs.writeShellScriptBin "vyke-menu-share" ''
    options=(
      "📋  Clipboard History"
      "📤  Share Clipboard (QR)"
      "📁  Share File"
      "📂  Share Folder"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Clipboard History"*)
        clipboard
        ;;
      *"Share Clipboard"*)
        ${pkgs.walker}/bin/walker --clipboard | ${pkgs.qrencode}/bin/qrencode -t UTF8
        ;;
      *"Share File"*)
        file=$(${pkgs.fd}/bin/fd -t f . ~/ | ${pkgs.walker}/bin/walker --dmenu)
        [ -n "$file" ] && ${pkgs.libnotify}/bin/notify-send "Selected: $file"
        ;;
      *"Share Folder"*)
        folder=$(${pkgs.fd}/bin/fd -t d . ~/ | ${pkgs.walker}/bin/walker --dmenu)
        [ -n "$folder" ] && ${pkgs.xfce.thunar}/bin/thunar "$folder"
        ;;
    esac
  '';
  
  # Config submenu (edit common config files)
  vyke-menu-config = pkgs.writeShellScriptBin "vyke-menu-config" ''
    config_dir="${config.var.configDirectory}"
    
    options=(
      "  Hyprland Config"
      "  Hyprland Bindings"
      "  Hyprland Animations"
      "  Walker Config"
      "  Waybar Config"
      "󰍜  HyprPanel Config"
      "  Terminal (${terminal})"
      "  Shell (Zsh)"
      "  Neovim"
      "  Git Config"
      "󰸌  Theme"
      "  Variables"
      "📂  Open Config Folder"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Hyprland Config"*)
        $EDITOR "$config_dir/modules/home-manager/system/hyprland/default.nix"
        ;;
      *"Hyprland Bindings"*)
        $EDITOR "$config_dir/modules/home-manager/system/hyprland/bindings.nix"
        ;;
      *"Hyprland Animations"*)
        $EDITOR "$config_dir/modules/home-manager/system/hyprland/animations.nix"
        ;;
      *"Walker"*)
        $EDITOR "$config_dir/modules/home-manager/programs/walker.nix"
        ;;
      *"Waybar"*)
        $EDITOR "$config_dir/modules/home-manager/system/waybar.nix"
        ;;
      *"HyprPanel"*)
        $EDITOR "$config_dir/modules/home-manager/system/hyprpanel.nix"
        ;;
      *"Terminal"*)
        $EDITOR "$config_dir/modules/home-manager/programs/${terminal}.nix"
        ;;
      *"Shell"*)
        $EDITOR "$config_dir/modules/home-manager/programs/shell/zsh.nix"
        ;;
      *"Neovim"*)
        $EDITOR "$config_dir/modules/home-manager/programs/nvf/default.nix"
        ;;
      *"Git"*)
        $EDITOR "$config_dir/modules/home-manager/programs/git.nix"
        ;;
      *"Theme"*)
        theme_file=$(${pkgs.fd}/bin/fd . "$config_dir/themes" -e nix | ${pkgs.walker}/bin/walker --dmenu)
        [ -n "$theme_file" ] && $EDITOR "$theme_file"
        ;;
      *"Variables"*)
        $EDITOR "$config_dir/hosts/ariandel/variables.nix"
        ;;
      *"Open Config Folder"*)
        ${pkgs.xfce.thunar}/bin/thunar "$config_dir"
        ;;
    esac
  '';
  
  # Scripts submenu (organized access to all utility scripts)
  vyke-menu-scripts = pkgs.writeShellScriptBin "vyke-menu-scripts" ''
    options=(
      "󰃉  Color Picker"
      "  Screenshot Tools"
      "⏺  Screen Recording"
      "📋  Clipboard Manager"
      "󰅶  Caffeine Toggle"
      "󰖔  Night Shift"
      "  Brightness Control"
      "  Volume Control"
      "  Tmux Sessionizer"
      "  Nerd Font Picker"
      "  Nixy (System Info)"
      "  System Monitor"
      "  Audio Mixer"
      "  WiFi Manager"
      "  VPN Toggle"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Color Picker"*)
        ${pkgs.hyprpicker}/bin/hyprpicker -a
        ;;
      *"Screenshot"*)
        vyke-menu-capture
        ;;
      *"Screen Recording"*)
        record-screen
        ;;
      *"Clipboard"*)
        clipboard
        ;;
      *"Caffeine"*)
        caffeine
        ;;
      *"Night Shift"*)
        night-shift
        ;;
      *"Brightness"*)
        show-brightness-menu
        ;;
      *"Volume"*)
        show-volume-menu
        ;;
      *"Tmux"*)
        ${terminal} -e tmux-sessionizer
        ;;
      *"Nerd Font"*)
        nerd-font-picker
        ;;
      *"Nixy"*)
        ${terminal} -e zsh -c nixy
        ;;
      *"System Monitor"*)
        ${terminal} -e btop
        ;;
      *"Audio Mixer"*)
        ${terminal} --class floating -e wiremix
        ;;
      *"WiFi"*)
        ${terminal} --class floating -e impala
        ;;
      *"VPN"*)
        openvpn-toggle
        ;;
    esac
  '';
  
  # Helper menus for brightness and volume
  show-brightness-menu = pkgs.writeShellScriptBin "show-brightness-menu" ''
    options=(
      "  Brightness Up"
      "  Brightness Down"
      "  Set to 100%"
      "  Set to 75%"
      "  Set to 50%"
      "  Set to 25%"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Up"*) brightness-up ;;
      *"Down"*) brightness-down ;;
      *"100%"*) brightness-set 100 ;;
      *"75%"*) brightness-set 75 ;;
      *"50%"*) brightness-set 50 ;;
      *"25%"*) brightness-set 25 ;;
    esac
  '';
  
  show-volume-menu = pkgs.writeShellScriptBin "show-volume-menu" ''
    options=(
      "  Volume Up"
      "  Volume Down"
      "  Mute Toggle"
      "  Set to 100%"
      "  Set to 75%"
      "  Set to 50%"
      "  Set to 25%"
    )
    
    selected=$(printf '%s\n' "''${options[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected" in
      *"Up"*) sound-up ;;
      *"Down"*) sound-down ;;
      *"Mute"*) sound-toggle ;;
      *"100%"*) sound-set 100 ;;
      *"75%"*) sound-set 75 ;;
      *"50%"*) sound-set 50 ;;
      *"25%"*) sound-set 25 ;;
    esac
  '';

in {
  home.packages = [
    vyke-menu
    vyke-menu-actions
    vyke-menu-capture
    vyke-menu-toggle
    vyke-menu-share
    vyke-menu-config
    vyke-menu-scripts
    show-brightness-menu
    show-volume-menu
    pkgs.qrencode  # For QR code sharing
  ];
}
