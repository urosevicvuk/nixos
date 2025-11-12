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
    ./tmux-sessionizer.nix
    ./status-icons.nix
    ./docker-status.nix
    ./network.nix

    # Keep old screenshot for compatibility
    ./screenshot.nix
  ];
}
