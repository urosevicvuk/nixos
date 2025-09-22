# NixTarter: Dev-First NixOS Distribution

## Core Vision
A developer-focused NixOS distribution where the primary selling point is seamless development environment management through dev shells and flakes. Rather than trying to be everything to everyone, focus on making development workflows frictionless.

## Key Differentiators

### 1. Dev Shells/Flakes as First-Class Citizens
- **Instant Dev Environments**: One command to get any project's development environment
- **Pre-built Common Stacks**: Ready-made flakes for popular frameworks (Next.js, Django, Go microservices, etc.)
- **Zero-Config Database Integration**: Automatic PostgreSQL, Redis, etc. setup in dev shells
- **Language Version Management**: Seamless switching between Node 18/20, Python 3.10/3.11, etc.
- **Tool Integration**: Pre-configured LSPs, formatters, debuggers for each language stack

### 2. Intelligent Device-Aware Defaults
The system adapts based on `hostDeviceType` set in each host's `variables.nix`:

#### Device Types & Smart Defaults
- **Desktop** (`anorLondo`): Performance-first, full feature set
  - Steam: enabled by default
  - Heavy development tools: enabled
  - Battery indicators: disabled
  - Multiple monitors: optimized layouts
  
- **Laptop** (`ariandel`): Battery-conscious, portable-focused
  - Steam: disabled by default
  - Power management: aggressive
  - Battery indicators: enabled
  - Bluetooth: optimized for peripherals
  
- **Server** (`fireLink`): Minimal, headless-optimized
  - GUI applications: disabled
  - Development tools: server-side only
  - Services: focused on backends/APIs
  - Security: hardened by default

- **Minimal-Laptop**: Ultra-lightweight for older hardware
  - Heavy IDEs: disabled
  - Animations: reduced
  - Resource-intensive apps: disabled

### 3. Comprehensive Module Options System
Every module should have:
- **Enable/disable toggles** for logical feature groups
- **Device-aware defaults** that make sense for the hardware
- **Granular control** for advanced users who want to override defaults
- **Dependency management** between related modules

## Implementation Strategy

### Phase 1: Module Standardization
1. **Audit existing modules** - identify which need options systems
2. **Create option schemas** - standardize how modules expose configuration
3. **Implement device-aware defaults** - logic based on `hostDeviceType`
4. **Add validation** - ensure configurations make sense for device types

### Phase 2: Dev Shell Ecosystem
1. **Create template flakes** for common development stacks
2. **Build dev shell management tools** - CLI for creating/managing environments
3. **Integration utilities** - seamless project detection and environment activation
4. **Documentation and examples** - make it trivial to get started

### Phase 3: Distribution Polish
1. **Installer/bootstrap script** - one-command setup for existing NixOS
2. **Configuration management** - tools for managing multiple hosts
3. **Community ecosystem** - sharing and discovering development environments
4. **Documentation site** - comprehensive guides and examples

## Module Architecture Example

```nix
# modules/nixos/gaming/steam.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.gaming.steam;
  deviceType = config.var.hostDeviceType or "desktop";
  
  # Smart defaults based on device type
  defaultEnabled = {
    desktop = true;
    laptop = false;
    server = false;
    minimal-laptop = false;
  }.${deviceType} or false;
in
{
  options.modules.gaming.steam = {
    enable = lib.mkEnableOption "Steam gaming platform" // {
      default = defaultEnabled;
      description = "Enable Steam (auto-enabled on desktop)";
    };
    
    compatibility = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Proton/Wine compatibility layers";
      };
    };
    
    hardware = {
      controllerSupport = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && (deviceType != "server");
        description = "Enable game controller support";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    hardware.steam-hardware.enable = cfg.hardware.controllerSupport;
    # ... rest of configuration
  };
}
```

## Target User Experience

### For New Users
```bash
# One command to transform existing NixOS into dev-focused setup
curl -sSL https://raw.githubusercontent.com/user/nixtarter/main/bootstrap.sh | bash

# Interactive setup wizard
nixtarter init --device-type laptop --preset web-dev
```

### For Daily Development
```bash
# Enter any project and get instant dev environment
cd my-nextjs-project
nix develop  # or `nixtarter dev` for enhanced experience

# Create new project with environment
nixtarter new react-typescript my-app
cd my-app && code .  # Everything just works
```

### For System Management
```bash
# Switch between development presets
nixtarter preset switch data-science
nixtarter preset switch mobile-dev

# Manage multiple hosts from single config
nixtarter deploy --host ariandel --preset minimal
```

## Success Metrics
- **Time to first development environment**: < 5 minutes from fresh NixOS
- **Popular framework coverage**: Pre-built flakes for top 20 development stacks
- **Configuration complexity**: 90% of users never need to write custom Nix
- **Performance**: Dev environments start in < 10 seconds
- **Reliability**: Reproducible builds across all supported device types

## Community Aspects
- **Flake registry**: Curated collection of development environments
- **Template sharing**: Community-contributed project templates
- **Device profiles**: Optimized configurations for popular laptop/desktop models
- **Integration guides**: Connecting with popular editors, tools, and workflows