# Development Shells Guide

> **Status:** 🚧 COMING SOON - This feature is planned as part of the NixTarter vision

Development shells are a core feature of the upcoming NixTarter distribution - providing instant, reproducible development environments for any project.

## Vision

The goal is to make development workflows frictionless by providing:

1. **Instant Dev Environments** - One command to get a project's complete development setup
2. **Pre-built Stacks** - Ready-made templates for popular frameworks
3. **Zero-Config** - Databases, tools, and dependencies automatically configured
4. **Reproducible** - Same environment everywhere, always

## Planned Features

### 🎯 Quick Start (Future)

```bash
# Enter any project and get instant dev environment
cd my-nextjs-project
nix develop

# Or create new project with environment
nix flake init -t github:urosevicvuk/nixos#react-typescript
cd my-app
nix develop
npm run dev  # Everything just works!
```

### 📦 Planned Templates

#### Web Development
- **react-typescript** - React + TypeScript + Vite
- **nextjs** - Next.js with TypeScript
- **vue** - Vue 3 + Vite + TypeScript
- **svelte** - SvelteKit
- **astro** - Astro static site generator

#### Backend Development
- **nodejs-express** - Node.js + Express + TypeScript
- **python-flask** - Python + Flask + PostgreSQL
- **python-django** - Django + PostgreSQL
- **go-api** - Go REST API with database
- **rust-actix** - Rust web service with Actix

#### Data Science
- **python-data** - Python + Jupyter + pandas + numpy
- **r-analysis** - R + RStudio + tidyverse
- **julia** - Julia with Pluto notebooks

#### Mobile Development
- **react-native** - React Native + Expo
- **flutter** - Flutter SDK

#### Systems Programming
- **c-cmake** - C + CMake + debugging tools
- **cpp-modern** - Modern C++ (C++20) setup
- **rust-cli** - Rust CLI application template

### 🛠️ Features Per Template

Each template will include:
- **Language runtime** - Correct version pinned
- **Build tools** - Compilers, bundlers, etc.
- **Package managers** - npm, pip, cargo, etc.
- **Development tools** - LSPs, formatters, linters
- **Databases** - PostgreSQL, Redis, etc. (containerized)
- **Editor integration** - VSCode settings, direnv config
- **Scripts** - Common tasks (test, build, deploy)

### 🔧 Template Structure (Example)

```nix
# templates/web/react-typescript/flake.nix
{
  description = "React TypeScript development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_20
          nodePackages.typescript
          nodePackages.typescript-language-server
          nodePackages.prettier
          nodePackages.eslint
        ];

        shellHook = ''
          echo "🚀 React TypeScript Development Environment"
          echo "Node: $(node --version)"
          echo "npm: $(npm --version)"
          echo ""
          echo "Get started:"
          echo "  npm install"
          echo "  npm run dev"
        '';
      };
  };
}
```

## Current Workaround

Until this feature is implemented, you can create per-project shells manually:

### Method 1: Project-local `flake.nix`

```nix
# In your project directory
{
  description = "My project dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_20
          # Add your dependencies
        ];
      };
    };
}
```

Then:
```bash
nix develop
```

### Method 2: Using `direnv`

Create `.envrc` in project:
```bash
use flake
```

The shell activates automatically when you `cd` into the directory.

## Implementation Roadmap

### Phase 1: Core Infrastructure (Q1 2025)
- [ ] Create `modules/nixos/development/devshells/` directory
- [ ] Implement base template structure
- [ ] Add 3-5 essential templates (web, python, rust)
- [ ] Write usage documentation

### Phase 2: Template Expansion (Q2 2025)
- [ ] Add 10+ framework templates
- [ ] Database integration (PostgreSQL, Redis)
- [ ] Docker Compose integration
- [ ] Template testing framework

### Phase 3: Tooling (Q2-Q3 2025)
- [ ] CLI tool for template management (`nixtarter` command)
- [ ] Interactive template wizard
- [ ] Project detection (auto-suggest templates)
- [ ] Template registry/sharing

### Phase 4: Advanced Features (Q3-Q4 2025)
- [ ] Multi-language project support
- [ ] Microservices templates
- [ ] CI/CD integration templates
- [ ] Cloud deployment helpers

## Why Development Shells?

### Traditional Setup:
```bash
# Install Node.js globally
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20

# Install Python
sudo apt install python3.11 python3-pip

# Install PostgreSQL
sudo apt install postgresql

# Configure everything...
# Hope it doesn't conflict with other projects...
```

### With Nix Dev Shells:
```bash
nix develop
# Everything is there, isolated, reproducible ✨
```

## Benefits

### For Developers:
- **Zero setup time** - Jump into any project instantly
- **Reproducible** - Same environment everywhere
- **Isolated** - Projects don't interfere with each other
- **Version-specific** - Use different Node versions per project
- **No global pollution** - Keep your system clean

### For Teams:
- **Onboarding** - New developers get started in minutes
- **Consistency** - Everyone has identical environments
- **Documentation as code** - `flake.nix` IS the setup guide
- **CI/CD** - Use the same environment in production

## Contributing

Want to help implement this feature?

1. Check the [nixtarter.md](../nixtarter.md) vision document
2. Look at the roadmap above
3. Create issues/PRs for template ideas
4. Share your own dev shell configurations

## Resources

- [Nix Dev Shells Official Docs](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [direnv Integration](https://direnv.net/)
- [NixTarter Vision](../nixtarter.md)

---

**Status: Planned Feature**

This documentation will be updated as the feature is implemented. Follow the repository for updates!
