# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### System Management
- `nixy` - Interactive system management wizard
- `nixy rebuild` - Rebuild current system configuration  
- `nixy upgrade` - Upgrade system with latest packages
- `nixy update` - Update flake inputs
- `nixy gc` - Garbage collection

### Direct NixOS Commands
- `sudo nixos-rebuild switch --flake .#anorLondo` - Desktop system
- `sudo nixos-rebuild switch --flake .#ariandel` - Laptop system  
- `sudo nixos-rebuild switch --flake .#fireLink` - Server system

### Development
- `nix develop` - Enter development shell (if available)
- `nix flake check` - Validate flake configuration
- `nix flake update` - Update flake inputs to latest versions

## Architecture

### Multi-Host Flake Configuration
This repository manages three NixOS systems using a single flake:
- **anorLondo**: Main desktop with Hyprland WM
- **ariandel**: Laptop configuration
- **fireLink**: Self-hosted server with media services

### Module Structure
```
modules/
├── nixos/     # System-level modules (audio, fonts, desktop environment)
├── home/      # Home-manager user modules (dotfiles, applications, scripts)  
└── server/    # Server-specific services (nextcloud, *arr stack, nginx)
```

### Configuration Pattern
Each host follows the structure:
```
hosts/{hostname}/
├── configuration.nix       # System imports and hardware-specific config
├── home.nix               # User environment via home-manager
├── variables.nix          # Host-specific variables
└── secrets/               # SOPS-encrypted secrets
```

### Key Design Decisions
- **Home-Manager Integration**: User environment managed at NixOS level via `home-manager.users.vyke`
- **Stylix Theming**: System-wide Gruvbox theme applied to all applications
- **Modular Organization**: Clear separation between system, user, and server concerns
- **SOPS Secrets**: Encrypted secrets management per host
- **Custom Scripts**: "nixy" wrapper provides simplified system management

### Development Environment
- **NVF Neovim**: Modern Neovim configuration with LSP and AI integration
- **Shell Setup**: Zsh with starship prompt, tmux, and development tools
- **Languages**: Go, Node.js, Python3, with associated tooling
- **No Traditional Dev Shells**: Development environment managed through home-manager packages instead of shell.nix

### Theming System
- **Stylix**: Declarative theming framework managing colors across all applications
- **Gruvbox Dark Medium**: Base16 color scheme with JetBrains Mono and SF Pro fonts
- **Wallpaper Management**: Automatic wallpaper fetching from gruvbox-wallpapers