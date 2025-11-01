{
  imports = [
    # Core utilities
    ./sounds.nix
    ./brightness.nix
    ./caffeine.nix
    ./hyprpanel.nix
    ./hyprfocus.nix
    ./night-shift.nix
    ./nerdfont-fzf.nix
    ./notification.nix
    ./system.nix
    ./openvpn.nix
    ./tmux-sessionizer.nix
    ./quick-toggles-status.nix
    ./network.nix
    
    # Enhanced features
    ./vyke-menu.nix              # Main menu system
    ./smart-screenshot.nix       # Advanced screenshot with smart detection
    ./keybindings-viewer.nix     # Searchable keybindings cheatsheet
    
    # Keep old screenshot for compatibility
    ./screenshot.nix
  ];
}
