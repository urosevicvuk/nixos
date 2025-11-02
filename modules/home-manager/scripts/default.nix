{
  imports = [
    # Core utilities
    ./sounds.nix
    ./mic.nix
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

    # Keep old screenshot for compatibility
    ./screenshot.nix
  ];
}
