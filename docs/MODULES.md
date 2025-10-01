# Module Reference

Complete documentation for all available NixOS modules in this configuration.

## Module Structure

All modules follow a consistent pattern:

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.<category>.<name>;
  deviceType = config.var.device or "desktop";

  # Smart defaults based on device type
  defaultEnabled = {
    desktop = true;
    laptop = false;
    server = false;
    minimal-laptop = false;
  }.${deviceType} or false;
in
{
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "description" // {
      default = defaultEnabled;
    };
    # Additional options...
  };

  config = lib.mkIf cfg.enable {
    # Module configuration...
  };
}
```

## Core Modules

Always enabled, essential for system operation.

### `core/nix.nix`
**Purpose:** Nix package manager and flake configuration

**Features:**
- Enables flakes and nix-command
- Automatic garbage collection (optional)
- Automatic system updates (optional)
- Optimized Nix settings

**Options:**
- `config.var.autoUpgrade` - Enable automatic system updates
- `config.var.autoGarbageCollector` - Enable automatic garbage collection

---

### `core/systemd-boot.nix`
**Purpose:** Systemd-boot bootloader configuration

**Features:**
- UEFI boot support
- Secure boot ready
- Clean boot entries

---

### `core/users.nix`
**Purpose:** User account management

**Features:**
- Creates user from `config.var.username`
- Sets up home directory
- Configures shell and groups

**Variables Required:**
- `config.var.username` - Primary user name

---

### `core/utils.nix`
**Purpose:** Essential system utilities

**Includes:**
- `git`, `wget`, `curl`
- `vim`, `neovim`
- `htop`, `btop`
- `zip`, `unzip`
- Network utilities
- File system tools

---

### `core/home-manager.nix`
**Purpose:** Home Manager integration

**Features:**
- Enables home-manager for user configurations
- Integrates with system configuration

---

## Desktop Modules

For systems with GUI environments.

### `desktop/audio.nix`
**Purpose:** Audio setup with PipeWire

**Features:**
- PipeWire audio server
- Low-latency audio support
- Bluetooth audio
- Audio effects (EasyEffects)

**Auto-enabled on:** Desktop, Laptop, Minimal Laptop
**Auto-disabled on:** Server

---

### `desktop/bluetooth.nix`
**Purpose:** Bluetooth device support

**Features:**
- Bluez Bluetooth stack
- Bluetooth audio profiles
- Device pairing management

**Auto-enabled on:** Desktop, Laptop, Minimal Laptop
**Auto-disabled on:** Server

---

### `desktop/fonts.nix`
**Purpose:** System font configuration

**Features:**
- Apple SF Pro fonts
- Nerd Fonts (JetBrainsMono, FiraCode)
- Font rendering optimization
- Emoji support

**Includes:**
- SF Pro (Display, Text, Rounded)
- NY font
- JetBrainsMono Nerd Font
- Font Awesome

---

### `desktop/hyprland.nix`
**Purpose:** Hyprland Wayland compositor

**Features:**
- Hyprland window manager
- Plugin support
- Performance optimizations
- XWayland support

**Configuration:** See home-manager Hyprland config

---

### `desktop/tuigreet.nix`
**Purpose:** TUI login manager

**Features:**
- Minimal TTY greeter
- Wayland session support
- Fast startup
- No graphical overhead

**Alternative:** `desktop/sddm.nix` for graphical login

---

## Development Modules

Tools and environments for software development.

### `development/docker.nix`
**Purpose:** Docker containerization

**Features:**
- Docker engine
- Docker Compose
- User added to docker group
- Rootless mode ready

**Auto-enabled on:** Desktop, Laptop, Minimal Laptop, Server

**Usage:**
```bash
docker run hello-world
docker-compose up
```

---

### `development/virtualization.nix`
**Purpose:** QEMU/KVM virtual machines

**Features:**
- QEMU virtualization
- KVM acceleration
- libvirt management
- virt-manager GUI

**Auto-enabled on:** Desktop
**Auto-disabled on:** Laptop, Minimal Laptop, Server

**Usage:**
```bash
virt-manager  # Launch VM manager
```

---

### `development/tools.nix`
**Purpose:** Development utilities and language runtimes

**Includes:**
- Build tools (gcc, cmake, make)
- Language runtimes (nodejs, python, rust)
- Version control (git, gh)
- Code editors and LSPs

**Auto-enabled on:** Desktop, Laptop

---

### `development/devshells/` (COMING SOON)

Pre-configured development environments:

- **web.nix** - React, Next.js, TypeScript
- **python.nix** - Python, pip, virtualenv
- **rust.nix** - Rust, cargo, rustfmt
- **go.nix** - Go toolchain
- **data.nix** - Jupyter, pandas, numpy

See [DEV-SHELLS.md](./DEV-SHELLS.md) for details.

---

## Gaming Modules

For gaming and entertainment.

### `gaming/steam.nix`
**Purpose:** Steam gaming platform

**Options:**
```nix
modules.gaming = {
  enable = <bool>;  # Auto: desktop=true, laptop=false

  steam.enable = <bool>;
  gamemode.enable = <bool>;
  gamescope.enable = <bool>;
};
```

**Features:**
- Steam with Proton
- GameMode for performance
- Gamescope compositor
- Controller support
- AMD GPU optimizations

**Auto-enabled on:** Desktop
**Auto-disabled on:** Laptop, Minimal Laptop, Server

**Override on laptop:**
```nix
modules.gaming.enable = true;
```

---

## Network Modules

Networking and connectivity.

### `network/tailscale.nix`
**Purpose:** Tailscale VPN for secure remote access

**Features:**
- Zero-config VPN
- Peer-to-peer connections
- Works across NAT
- Automatic DNS

**Auto-enabled on:** All device types

**Setup:**
```bash
sudo tailscale up
# Follow auth URL
tailscale status
```

**Usage:**
```bash
# SSH to another Tailscale device
ssh vyke@firelink

# Access services
curl http://firelink:8080
```

---

## Server Modules

For headless server configurations.

### `server/ssh.nix`
**Purpose:** Secure SSH server

**Features:**
- SSH server on port 22
- Key-based authentication only
- No root login
- No password authentication
- Firewall rule included

**Configuration:**
```nix
users.users."${config.var.username}" = {
  openssh.authorizedKeys.keyFiles = [
    config.sops.secrets.ssh-public-key.path
  ];
};
```

**Auto-enabled on:** Server

---

### `server/firewall.nix`
**Purpose:** Basic firewall configuration

**Features:**
- Firewall enabled by default
- SSH port allowed
- Configurable rules

**Auto-enabled on:** Server

---

### `server/web/nginx.nix`
**Purpose:** Nginx web server

**Features:**
- Nginx reverse proxy
- SSL/TLS with Let's Encrypt (ACME)
- Cloudflare DNS challenge
- Virtual host management

**Configuration:**
```nix
services.nginx.virtualHosts."example.com" = {
  enableACME = true;
  forceSSL = true;
  locations."/" = {
    proxyPass = "http://127.0.0.1:3000";
  };
};
```

**Requires:** Domain, Cloudflare API token (in sops)

---

### `server/media/arr.nix`
**Purpose:** Media automation stack

**Features:**
- Jellyfin media server
- Jellyseerr request management
- Radarr (movies)
- Sonarr (TV shows)
- Prowlarr (indexer manager)
- Transmission (torrent client)
- Bazarr (subtitles)
- VPN integration (WireGuard)

**Requires:** `nixarr` flake input

---

### `server/services/bitwarden.nix`
**Purpose:** Vaultwarden password manager

**Features:**
- Self-hosted Bitwarden server
- Web vault interface
- Browser extension support
- Nginx reverse proxy integration

---

### `server/services/adguardhome.nix`
**Purpose:** DNS-based ad blocker

**Features:**
- Network-wide ad blocking
- DNS server
- Web interface on port 3000
- Query logging and statistics

---

### `server/services/glance.nix`
**Purpose:** Personal dashboard

**Features:**
- Customizable homepage
- Service status monitoring
- Weather widget
- Bookmark management
- RSS feeds

---

### Other Server Services:
- **mealie.nix** - Recipe manager
- **nextcloud.nix** - File sync and collaboration
- **headscale.nix** - Self-hosted Tailscale control server
- **hoarder.nix** - Bookmark manager
- **meilisearch.nix** - Fast search engine

---

## Home Manager Modules

User-level application configurations in `modules/home-manager/programs/`:

- **btop/** - System monitor
- **development/** - Dev tools (VSCode, etc)
- **direnv/** - Environment switcher
- **git/** - Git configuration
- **kitty/** - Terminal emulator
- **nvf/** - Neovim config
- **shell/** - Shell (zsh) config
- **spicetify/** - Spotify theming
- **thunar/** - File manager
- **wofi/** - App launcher
- **zen/** - Zen browser
- **zathura/** - PDF viewer

See individual module files for detailed configuration options.

---

## Using Modules

### In Host Configuration:

```nix
# hosts/anorLondo/configuration.nix
{
  imports = [
    ../profiles/desktop.nix
    # Override or add modules:
    ../../modules/nixos/server/web/nginx.nix
  ];

  # Configure module options:
  modules.gaming.enable = true;
  modules.gaming.steam.enable = true;
}
```

### In Profiles:

```nix
# hosts/profiles/custom.nix
{ ... }:
{
  imports = [
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/desktop/audio.nix
    # ... more modules
  ];
}
```

### Override Defaults:

```nix
# Enable module normally disabled on laptop
modules.gaming = {
  enable = true;
  steam.enable = true;
  gamemode.enable = false;  # But disable gamemode
};
```

---

## Creating New Modules

Follow the module template:

```nix
# modules/nixos/category/mymodule.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.category.mymodule;
  deviceType = config.var.device or "desktop";

  defaultEnabled = {
    desktop = true;
    laptop = true;
    server = false;
    minimal-laptop = false;
  }.${deviceType} or false;
in
{
  options.modules.category.mymodule = {
    enable = lib.mkEnableOption "My Module" // {
      default = defaultEnabled;
      description = "Enable My Module";
    };

    # Additional options
  };

  config = lib.mkIf cfg.enable {
    # Your configuration here
  };
}
```

Then import in appropriate profile(s).

---

## Next Steps

- Read [DEVICES.md](./DEVICES.md) for device-specific configurations
- See [DEV-SHELLS.md](./DEV-SHELLS.md) for development environments (coming soon)
- Check main [README.md](../README.md) for usage examples
