# NixOS Configuration

A developer-focused NixOS configuration featuring device-aware defaults, modular architecture, and seamless development environment management. Built with the [NixTarter](./nixtarter.md) philosophy in mind.

## 🚀 Quick Start

### For New Installations

1. **Install NixOS** on your machine
2. **Clone this repository:**
   ```bash
   git clone https://github.com/urosevicvuk/nixos ~/nixos
   cd ~/nixos
   ```
3. **Choose your device profile:**
   - Desktop: `sudo nixos-rebuild switch --flake .#anorLondo`
   - Laptop: `sudo nixos-rebuild switch --flake .#ariandel`
   - Server: `sudo nixos-rebuild switch --flake .#firelink`

### For Existing Systems

```bash
cd ~/nixos
sudo nixos-rebuild switch --flake .#<hostname>
```

## 📁 Repository Structure

```
nixos/
├── flake.nix                    # Flake configuration with inputs and outputs
├── hosts/                       # Host-specific configurations
│   ├── profiles/               # Device type profiles
│   │   ├── desktop.nix         # Full-featured desktop setup
│   │   ├── laptop.nix          # Battery-optimized laptop setup
│   │   ├── server.nix          # Headless server setup
│   │   └── minimal-laptop.nix  # Lightweight for older hardware
│   ├── anorLondo/              # Main desktop (NixOS)
│   ├── ariandel/               # Laptop (NixOS)
│   ├── ariandelMinimal/        # Minimal laptop (NixOS)
│   └── firelink/               # Server (NixOS)
├── modules/
│   ├── nixos/                  # NixOS system-level modules (Linux)
│   │   ├── core/              # Essential modules (nix, boot, users)
│   │   ├── desktop/           # Desktop environment (audio, GUI, fonts)
│   │   ├── development/       # Dev tools (docker, virtualization)
│   │   ├── gaming/            # Gaming setup (steam, gamemode)
│   │   ├── network/           # Networking (tailscale)
│   │   └── server/            # Server services
│   │       ├── web/          # Web servers (nginx)
│   │       ├── media/        # Media services (arr stack)
│   │       └── services/     # Other services (bitwarden, etc)
│   ├── darwin/                # macOS-specific modules (via nix-darwin)
│   │   ├── system/           # macOS system settings, Homebrew
│   │   ├── desktop/          # Window managers (Yabai, AeroSpace)
│   │   └── apps/             # macOS applications
│   ├── wsl/                   # WSL-specific modules (NixOS on Windows)
│   │   ├── core/             # WSL configuration, Windows interop
│   │   └── tweaks/           # Performance optimizations
│   └── home-manager/          # User-level configurations (cross-platform!)
│       └── programs/          # Application configs
├── themes/                     # System theming (Stylix)
└── docs/                       # Documentation
```

## 🎯 Multi-Platform Support

This configuration supports **NixOS**, **macOS (via nix-darwin)**, and **WSL (NixOS on Windows)**.

### Platform Overview

| Platform | Base | System Modules | User Config |
|----------|------|----------------|-------------|
| **NixOS** | Full Linux OS | `modules/nixos/*` | home-manager |
| **macOS** | macOS + Nix | `modules/darwin/*` | home-manager |
| **WSL** | NixOS on Windows | `modules/nixos/*` + `modules/wsl/*` | home-manager |

### NixOS (Primary Platform)

Full NixOS configurations with device-specific profiles:

#### Desktop (`anorLondo`)
- **Purpose:** High-performance workstation
- **Features:** Gaming (Steam), full development tools, virtualization
- **Optimized for:** Performance, multiple monitors
- **Auto-enabled:** Steam, heavy IDEs, virtualization

#### Laptop (`ariandel`)
- **Purpose:** Portable development machine
- **Features:** Battery management, Bluetooth peripherals
- **Optimized for:** Battery life, portability
- **Auto-disabled:** Steam, heavy virtualization

#### Server (`firelink`)
- **Purpose:** Headless server for remote services
- **Features:** SSH, Docker, Tailscale for remote access
- **Optimized for:** Security, minimal resource usage
- **Auto-disabled:** All GUI applications

#### Minimal Laptop (`ariandelMinimal`)
- **Purpose:** Older hardware with limited resources
- **Features:** Lightweight desktop, basic development
- **Optimized for:** Low resource usage
- **Auto-disabled:** Virtualization, animations, heavy apps

### macOS (Darwin) - Ready for Setup

Nix-darwin modules for macOS system configuration:

```bash
# When you get a Mac, uncomment in flake.nix and:
darwin-rebuild switch --flake .#macbook
```

**Available modules:**
- System defaults (Dock, Finder, keyboard)
- Homebrew integration for Mac apps
- Window managers (Yabai, AeroSpace, skhd)
- Native macOS applications

See [modules/darwin/README.md](modules/darwin/README.md) for details.

### WSL (NixOS on Windows) - Ready for Setup

Run NixOS on Windows with WSL-specific tweaks:

```bash
# When setting up WSL, uncomment in flake.nix and:
sudo nixos-rebuild switch --flake .#wsl-dev
```

**Features:**
- Uses most NixOS modules (it's still NixOS!)
- Windows interoperability
- Performance optimizations for WSL2
- Can use Docker Desktop or native Docker

See [modules/wsl/README.md](modules/wsl/README.md) for details.

## 🧩 Module System

All modules follow a consistent pattern with device-aware defaults:

```nix
# Example: gaming/steam.nix
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "gaming support" // {
      default = deviceType == "desktop";  # Smart defaults!
    };
    steam.enable = lib.mkOption {
      default = cfg.enable;
    };
  };
}
```

### Core Modules (Always Enabled)
- **nix.nix** - Nix package manager configuration
- **systemd-boot.nix** - Boot loader setup
- **users.nix** - User account management
- **utils.nix** - Essential system utilities
- **home-manager.nix** - Home Manager integration

### Desktop Modules
- **audio.nix** - PipeWire audio setup
- **bluetooth.nix** - Bluetooth support
- **fonts.nix** - Font configuration
- **hyprland.nix** - Hyprland compositor
- **tuigreet.nix** - Login manager

### Development Modules
- **docker.nix** - Docker containerization
- **virtualization.nix** - QEMU/KVM virtual machines
- **tools.nix** - Development utilities
- **devshells/** - Pre-configured dev environments (COMING SOON!)

### Gaming Modules
- **steam.nix** - Steam with Proton support (auto-enabled on desktop)

### Server Modules
- **ssh.nix** - Secure SSH server
- **firewall.nix** - Firewall configuration
- **web/nginx.nix** - Nginx web server
- **services/bitwarden.nix** - Vaultwarden password manager
- **media/arr.nix** - Media automation (Sonarr, Radarr, etc)

## 🔧 Common Tasks

### Adding a New Host

1. Create host directory:
   ```bash
   mkdir -p hosts/newhost/{secrets}
   ```

2. Create configuration files:
   ```bash
   # hosts/newhost/configuration.nix
   {
     imports = [
       ../profiles/desktop.nix  # or laptop.nix, server.nix
       ./hardware-configuration.nix
       ./variables.nix
     ];
   }
   ```

3. Add to flake.nix:
   ```nix
   nixosConfigurations.newhost = nixpkgs.lib.nixosSystem {
     modules = [ ./hosts/newhost/configuration.nix ];
   };
   ```

### Enabling Optional Modules

Simply import them in your host's configuration:

```nix
# hosts/anorLondo/configuration.nix
{
  imports = [
    ../profiles/desktop.nix
    # Add optional modules:
    ../../modules/nixos/server/web/nginx.nix
  ];
}
```

### Overriding Device Defaults

Use module options to override smart defaults:

```nix
# Enable Steam on laptop (normally disabled)
modules.gaming.enable = true;
modules.gaming.steam.enable = true;
```

### Managing Secrets with SOPS

1. **Set up age key:**
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

2. **Add secrets to host's secrets.yaml:**
   ```bash
   cd hosts/firelink/secrets
   sops secrets.yaml
   ```

3. **Reference in modules:**
   ```nix
   config.sops.secrets.ssh-public-key.path
   ```

## 🌐 Remote Server Access

### Setting Up a Remote Server (e.g., firelink)

1. **Install NixOS** on the server machine
2. **Connect to Tailscale:**
   ```bash
   sudo tailscale up
   ```
3. **From your main PC, SSH into it:**
   ```bash
   ssh vyke@firelink  # or use Tailscale IP
   ```
4. **Make remote changes:**
   ```bash
   cd ~/nixos
   nvim hosts/firelink/configuration.nix
   sudo nixos-rebuild switch --flake .#firelink
   ```

See [hosts/firelink/secrets/README.md](hosts/firelink/secrets/README.md) for SSH key setup.

## 🚧 Development Shells (Coming Soon!)

Part of the NixTarter vision - pre-configured development environments:

```bash
# Enter a project and get instant dev environment
cd my-nextjs-project
nix develop  # Everything just works!

# Create new project with environment
nix flake init -t github:urosevicvuk/nixos#react-typescript
```

**Planned templates:**
- Web development (React, Next.js, Vue)
- Backend (Go, Rust, Python)
- Data science (Python, Jupyter, R)
- Mobile (React Native, Flutter)
- Systems programming (C, C++, Rust)

See [nixtarter.md](./nixtarter.md) for the full vision.

## 📚 Documentation

- **[NixTarter Plan](./nixtarter.md)** - Vision and roadmap for this distribution
- **[Device Types](./docs/DEVICES.md)** - Detailed device type documentation
- **[Module Reference](./docs/MODULES.md)** - Complete module documentation
- **[Dev Shells Guide](./docs/DEV-SHELLS.md)** - Development environment guide (coming soon)

## 🛠️ Flake Inputs

- **nixpkgs** - Main package repository (unstable)
- **home-manager** - User environment management
- **hyprland** - Wayland compositor
- **stylix** - System-wide theming
- **sops-nix** - Secrets management
- **nvf** - Neovim configuration framework
- **ghostty** - GPU-accelerated terminal

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use it as inspiration for your own setup
- Submit issues for bugs or suggestions
- Fork and adapt to your needs

## 📝 License

MIT License - See [LICENSE](./LICENSE) for details

## 🔗 Links

- **Repository:** https://github.com/urosevicvuk/nixos
- **NixOS:** https://nixos.org
- **Home Manager:** https://github.com/nix-community/home-manager
- **Hyprland:** https://hyprland.org

---

**Built with ❤️ using NixOS**
