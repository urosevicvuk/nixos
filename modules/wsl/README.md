# WSL Modules

This directory contains WSL-specific modules for NixOS on Windows Subsystem for Linux.

## Overview

WSL runs **NixOS** on Windows, so you can use most regular NixOS modules! These modules only add WSL-specific tweaks and Windows interop features.

## Structure

```
wsl/
├── core/
│   ├── wsl-config.nix  # Basic WSL configuration
│   └── interop.nix     # Windows-WSL interoperability
└── tweaks/
    └── performance.nix # Performance optimizations
```

## Key Concepts

### WSL = NixOS + WSL Tweaks

- **WSL runs NixOS:** You can use almost all NixOS modules
- **WSL modules:** Only add Windows-specific features
- **Can't use:** GUI modules (Hyprland, gaming) unless using WSLg

### What Works

| Feature | WSL |
|---------|-----|
| NixOS modules | ✅ Most |
| Docker | ✅ Yes (native or Docker Desktop) |
| Development tools | ✅ Yes |
| Systemd | ✅ Yes |
| GUI apps (WSLg) | ✅ Limited |
| Gaming | ❌ No |
| Desktop environments | ❌ No (use WSLg for basic X11) |

## Usage

### Example Host Configuration

```nix
# hosts/wsl-dev/configuration.nix
{ config, ... }:
{
  imports = [
    # WSL-specific
    ../../modules/wsl/core/wsl-config.nix
    ../../modules/wsl/core/interop.nix
    ../../modules/wsl/tweaks/performance.nix

    # Regular NixOS modules work!
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/development/tools.nix
    ../../modules/nixos/network/tailscale.nix

    # Host-specific
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # WSL configuration
  modules.wsl.core.enable = true;
  modules.wsl.interop.enable = true;
  modules.wsl.tweaks.performance.enable = true;

  # Regular NixOS configuration
  modules.development.docker.enable = true;

  system.stateVersion = "24.05";
}
```

### Building on WSL

```bash
# Build and activate WSL configuration
sudo nixos-rebuild switch --flake .#wsl-dev
```

## Available Modules

### Core Modules

**wsl-config.nix** - Basic WSL setup
- Enables WSL integration
- Sets default user
- Configures automount and networking
- Disables unnecessary services

**interop.nix** - Windows interoperability
- Run Windows executables from WSL
- Access Windows PATH
- Shell aliases for Windows apps
- wslu utilities

### Tweaks

**performance.nix** - Performance optimizations
- Limit journal size
- Disable unnecessary services
- Optimize filesystem
- Swap configuration
- Faster boot

## Windows Integration

### Accessing Windows Files

Windows drives are mounted at `/mnt/`:
```bash
cd /mnt/c/Users/vuk23/
```

### Running Windows Programs

```bash
# Open Windows Explorer
explorer.exe .

# Use VS Code from Windows
code.exe myfile.txt

# PowerShell
powershell.exe -Command "Get-Process"
```

### Using Windows Docker Desktop

If using Docker Desktop on Windows:

```nix
# Don't enable docker-native in wsl-config.nix
wsl.docker-native.enable = false;

# Docker commands will use Windows Docker Desktop
```

### Using Native WSL Docker

```nix
# Enable in wsl-config.nix
wsl.docker-native.enable = true;

# Or use regular NixOS Docker module
modules.development.docker.enable = true;
```

## WSLg (GUI Support)

WSL2 supports running GUI applications via WSLg:

```nix
# GUI apps work with WSLg
environment.systemPackages = with pkgs; [
  firefox
  vscode
  # But it's limited - no Hyprland/gaming
];
```

**Limitations:**
- Basic X11 support only
- No Wayland compositors
- No gaming
- Performance not ideal

**Better approach:** Use Windows apps + WSL terminal

## Installation

### From Windows

1. **Enable WSL:**
   ```powershell
   wsl --install
   ```

2. **Download NixOS-WSL:**
   Get from [nix-community/NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases)

3. **Import:**
   ```powershell
   wsl --import NixOS .\NixOS\ nixos-wsl.tar.gz
   ```

4. **Enter:**
   ```powershell
   wsl -d NixOS
   ```

5. **Clone config and build:**
   ```bash
   git clone https://github.com/urosevicvuk/nixos ~/nixos
   cd ~/nixos
   sudo nixos-rebuild switch --flake .#wsl-dev
   ```

## Tips

### VSCode Integration

Use "WSL" extension in VS Code (Windows):
- Open WSL folders directly in VS Code
- Extensions run in WSL
- Terminal uses WSL shell

### File Performance

- **Fast:** `/home/` (native WSL filesystem)
- **Slow:** `/mnt/c/` (Windows filesystem)
- **Tip:** Keep projects in WSL home directory

### Memory Limit

Create `.wslconfig` in Windows `%USERPROFILE%`:
```ini
[wsl2]
memory=8GB
processors=4
swap=0
```

## Resources

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [WSLg](https://github.com/microsoft/wslg)

## TODO

- [ ] Add example WSL host configuration
- [ ] Test Docker integration options
- [ ] Document GUI app setup with WSLg
- [ ] Add systemd service examples for Windows interop
