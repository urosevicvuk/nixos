# Device Types Guide

This document explains the different device types supported by this NixOS configuration and their smart defaults.

## Overview

Each device type has a profile in `hosts/profiles/` that automatically imports appropriate modules with sensible defaults. The system adapts based on the `device` variable set in each host's `variables.nix`.

## Device Types

### 🖥️ Desktop

**Profile:** `hosts/profiles/desktop.nix`
**Example Host:** `anorLondo`
**Use Case:** High-performance workstation for development, gaming, and content creation

#### Auto-Enabled Features:
- ✅ Steam and gaming support
- ✅ Full virtualization (QEMU/KVM)
- ✅ Heavy development tools
- ✅ Multi-monitor support
- ✅ High-performance audio (low latency)

#### Auto-Disabled Features:
- ❌ Battery indicators
- ❌ Power management optimizations

#### Included Modules:
```nix
{
  imports = [
    # Core
    ../../modules/nixos/core/*

    # Desktop Environment
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/tuigreet.nix

    # Development
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/development/virtualization.nix
    ../../modules/nixos/development/tools.nix

    # Gaming
    ../../modules/nixos/gaming/steam.nix  # Auto-enabled

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
```

#### Ideal Hardware:
- Desktop PC with dedicated GPU
- 16GB+ RAM
- High-performance CPU
- Multiple monitors
- Gaming peripherals

---

### 💻 Laptop

**Profile:** `hosts/profiles/laptop.nix`
**Example Host:** `ariandel`
**Use Case:** Portable development machine with battery optimization

#### Auto-Enabled Features:
- ✅ Battery indicators
- ✅ Power management
- ✅ Bluetooth for peripherals
- ✅ Development tools (Docker)
- ✅ Adaptive brightness

#### Auto-Disabled Features:
- ❌ Steam (can be manually enabled)
- ❌ Heavy virtualization
- ❌ Performance-intensive features

#### Included Modules:
```nix
{
  imports = [
    # Core
    ../../modules/nixos/core/*

    # Desktop Environment (power-optimized)
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/tuigreet.nix

    # Development (lightweight)
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/development/tools.nix

    # Gaming (disabled by default)
    ../../modules/nixos/gaming/steam.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
```

#### Ideal Hardware:
- Modern laptop (2020+)
- 8GB+ RAM
- SSD storage
- Good battery life
- Integrated or dedicated GPU

---

### 🖥️ Minimal Laptop

**Profile:** `hosts/profiles/minimal-laptop.nix`
**Example Host:** `ariandelMinimal`
**Use Case:** Older hardware with limited resources

#### Auto-Enabled Features:
- ✅ Lightweight desktop environment
- ✅ Essential development tools
- ✅ Power management
- ✅ Reduced animations

#### Auto-Disabled Features:
- ❌ Gaming
- ❌ Virtualization
- ❌ Heavy IDEs
- ❌ Resource-intensive apps
- ❌ Compositor effects

#### Included Modules:
```nix
{
  imports = [
    # Core
    ../../modules/nixos/core/*

    # Minimal Desktop
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/bluetooth.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/hyprland.nix  # Minimal config
    ../../modules/nixos/desktop/tuigreet.nix

    # Minimal Development
    ../../modules/nixos/development/docker.nix

    # Network
    ../../modules/nixos/network/tailscale.nix
  ];
}
```

#### Ideal Hardware:
- Older laptops (2015-2019)
- 4GB+ RAM
- Any storage (HDD acceptable)
- Integrated graphics
- Limited battery capacity

---

### 🌐 Server

**Profile:** `hosts/profiles/server.nix`
**Example Host:** `firelink`
**Use Case:** Headless server for remote services

#### Auto-Enabled Features:
- ✅ SSH server
- ✅ Firewall
- ✅ Docker for services
- ✅ Tailscale for remote access
- ✅ Minimal resource usage

#### Auto-Disabled Features:
- ❌ All GUI applications
- ❌ Desktop environment
- ❌ Gaming
- ❌ Audio
- ❌ Bluetooth

#### Included Modules:
```nix
{
  imports = [
    # Core
    ../../modules/nixos/core/*

    # Server Essentials
    ../../modules/nixos/development/docker.nix
    ../../modules/nixos/network/tailscale.nix
    ../../modules/nixos/server/ssh.nix
    ../../modules/nixos/server/firewall.nix

    # Optional services (commented by default):
    # ../../modules/nixos/server/web/nginx.nix
    # ../../modules/nixos/server/media/arr.nix
    # ../../modules/nixos/server/services/bitwarden.nix
  ];
}
```

#### Ideal Hardware:
- Any server-grade hardware
- Headless (no monitor)
- Network connectivity
- Adequate storage for services
- 4GB+ RAM recommended

---

## Choosing a Device Type

### Decision Tree:

```
Is this a server (no GUI needed)?
├─ Yes → Use server profile
└─ No → Is it a laptop?
    ├─ Yes → Is the hardware older (pre-2020) or limited?
    │   ├─ Yes → Use minimal-laptop profile
    │   └─ No → Use laptop profile
    └─ No → Use desktop profile (default)
```

## Customizing Device Profiles

### Override in Host Configuration:

```nix
# hosts/ariandel/configuration.nix
{
  imports = [
    ../profiles/laptop.nix
  ];

  # Override: Enable gaming on laptop
  modules.gaming.enable = true;
  modules.gaming.steam.enable = true;
}
```

### Create Custom Profile:

```nix
# hosts/profiles/workstation.nix
{ ... }:
{
  imports = [
    ../profiles/desktop.nix
  ];

  # Disable gaming for work machine
  modules.gaming.enable = false;

  # Add extra development tools
  # ...
}
```

## Variables Configuration

Each host sets its device type in `variables.nix`:

```nix
# hosts/anorLondo/variables.nix
{
  config.var = {
    hostname = "anorLondo";
    device = "desktop";  # desktop | laptop | server | minimal-laptop
    # ...
  };
}
```

This variable is used by modules to determine smart defaults.

## Profile Comparison Table

| Feature | Desktop | Laptop | Minimal Laptop | Server |
|---------|---------|--------|----------------|--------|
| Steam | ✅ Auto | ❌ Default | ❌ | ❌ |
| Virtualization | ✅ | ❌ | ❌ | ❌ |
| Docker | ✅ | ✅ | ✅ | ✅ |
| GUI | ✅ | ✅ | ✅ | ❌ |
| Audio | ✅ | ✅ | ✅ | ❌ |
| Bluetooth | ✅ | ✅ | ✅ | ❌ |
| Power Mgmt | ❌ | ✅ | ✅ | ❌ |
| Tailscale | ✅ | ✅ | ✅ | ✅ |
| SSH Server | ❌ | ❌ | ❌ | ✅ |

## Next Steps

- Read [MODULES.md](./MODULES.md) for detailed module documentation
- See [README.md](../README.md) for general configuration guide
- Check [DEV-SHELLS.md](./DEV-SHELLS.md) for development environments (coming soon)
