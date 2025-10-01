# Darwin (macOS) Modules

This directory contains macOS-specific modules using nix-darwin.

## Overview

These modules are **only** for macOS systems. They cannot be used on NixOS or WSL.

## Structure

```
darwin/
├── system/          # System-level configuration
│   ├── defaults.nix   # macOS system preferences
│   └── homebrew.nix   # Homebrew package management
├── desktop/         # Desktop environment & window managers
│   ├── yabai.nix      # Yabai tiling WM (requires SIP disabled)
│   ├── skhd.nix       # Hotkey daemon
│   └── aerospace.nix  # AeroSpace WM (no SIP required)
└── apps/            # GUI applications
    └── mac-apps.nix   # Common macOS apps
```

## Key Concepts

### nix-darwin vs NixOS

- **nix-darwin:** System configuration framework for macOS
- **NixOS:** Full Linux distribution (can't run on macOS)
- **Limitations:** No systemd, different init system, macOS-specific APIs

### What Works Where

| Feature | nix-darwin | home-manager |
|---------|------------|--------------|
| System preferences | ✅ Yes | ❌ No |
| Homebrew | ✅ Yes | ❌ No |
| User apps/config | ❌ No | ✅ Yes |
| CLI tools | ✅ Both | ✅ Both |

## Usage

### Example Host Configuration

```nix
# hosts/macbook/configuration.nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/darwin/system/defaults.nix
    ../../modules/darwin/system/homebrew.nix
    ../../modules/darwin/desktop/aerospace.nix
    ../../modules/darwin/apps/mac-apps.nix
  ];

  # Enable modules
  modules.darwin.system.defaults.enable = true;
  modules.darwin.system.homebrew.enable = true;
  modules.darwin.desktop.aerospace.enable = true;

  # User configuration via home-manager
  home-manager.users.vyke = {
    imports = [
      ../../home-manager/programs/git
      ../../home-manager/programs/nvf
      ../../home-manager/programs/shell
    ];
  };

  # System settings
  system.stateVersion = 4;
}
```

### Building on macOS

```bash
# Build and activate darwin configuration
darwin-rebuild switch --flake .#macbook

# Or if not installed yet:
nix run nix-darwin -- switch --flake .#macbook
```

## Available Modules

### System Modules

**defaults.nix** - macOS system preferences
- Dock settings (autohide, size, position)
- Finder settings (show extensions, pathbar)
- Keyboard settings (repeat rate)
- Trackpad settings

**homebrew.nix** - Package management
- Homebrew formulae (CLI tools)
- Casks (GUI apps)
- Mac App Store apps

### Desktop Modules

**yabai.nix** - Tiling window manager
- Binary space partitioning layout
- Automatic window tiling
- Requires SIP disabled for full features

**skhd.nix** - Hotkey daemon
- Keyboard shortcuts
- Often paired with Yabai
- Vi-like keybindings

**aerospace.nix** - Modern tiling WM
- No SIP disabling required
- Simpler than Yabai
- Active development

### App Modules

**mac-apps.nix** - Common applications
- Template for GUI apps
- Installed via Homebrew casks
- Customize per host

## System Integrity Protection (SIP)

Some features require disabling SIP:

### Full Yabai Features
1. Reboot into Recovery Mode (Cmd+R on startup)
2. Open Terminal
3. Run: `csrutil disable`
4. Reboot

### Re-enable SIP
```bash
csrutil enable
```

**Note:** AeroSpace doesn't require SIP disabling!

## Resources

- [nix-darwin documentation](https://daiderd.com/nix-darwin/)
- [Yabai](https://github.com/koekeishiya/yabai)
- [skhd](https://github.com/koekeishiya/skhd)
- [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- [Homebrew](https://brew.sh/)

## TODO

- [ ] Add example macOS host configuration
- [ ] Create sketchybar module for status bar
- [ ] Add Raycast/Alfred launcher module
- [ ] Document Homebrew best practices
