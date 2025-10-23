{
  # https://github.com/urosevicvuk/nixos
  description = ''
    Goated nixos setup
  '';

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS support (uncomment when needed)
    # darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # WSL support (uncomment when needed)
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix"; # SOPS integration for NixOS
    };

    stylix = {
      url = "github:danth/stylix";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    elephant = {
      url = "github:abenz1267/elephant/v2.2.5";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    winboat = {
      url = "github:TibixDev/winboat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-stable, ... }:
    {
      # NixOS configurations
      nixosConfigurations = {
        # anorLondo is the main desktop system
        anorLondo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              _module.args = { inherit inputs; };

              nixpkgs.overlays = [
                (final: prev: {
                  stable = import nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
              ];
            }
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/anorLondo/configuration.nix
          ];
        };

        # ariandel is the laptop
        ariandel = nixpkgs.lib.nixosSystem {
          modules = [
            {
              _module.args = { inherit inputs; };

              nixpkgs.overlays = [
                (final: prev: {
                  stable = import nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
                (final: prev: {
                  elephant-providers = prev.elephant-providers.overrideAttrs (old: {
                    buildPhase = ''
                      runHook preBuild
                      ${old.buildPhase or ""}
                      runHook postBuild
                    ''
                    + ''
                      # Ignore windows provider build failure
                      true
                    '';
                  });
                })
              ];
            }
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/ariandel/configuration.nix
          ];
        };

        # firelink is the server
        firelink = nixpkgs.lib.nixosSystem {
          modules = [
            {
              _module.args = { inherit inputs; };
              nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
            }
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.sops-nix.nixosModules.sops
            inputs.nix-minecraft.nixosModules.minecraft-servers
            # inputs.nixarr.nixosModules.default  # Enable when nixarr input is added and configured
            # inputs.search-nixos-api.nixosModules.search-nixos-api  # Enable when search-nixos-api input is added
            ./hosts/firelink/configuration.nix
          ];
        };

        # WSL configuration (uncomment when needed)
        # wsl-dev = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     { _module.args = { inherit inputs; }; }
        #     inputs.nixos-wsl.nixosModules.wsl
        #     inputs.home-manager.nixosModules.home-manager
        #     ./hosts/wsl-dev/configuration.nix
        #   ];
        # };
      };

      # macOS configurations (uncomment when needed)
      # darwinConfigurations = {
      #   macbook = inputs.darwin.lib.darwinSystem {
      #     system = "aarch64-darwin";  # Apple Silicon (use x86_64-darwin for Intel)
      #     modules = [
      #       { _module.args = { inherit inputs; }; }
      #       inputs.home-manager.darwinModules.home-manager
      #       ./hosts/macbook/configuration.nix
      #     ];
      #   };
      # };

      # Development environment templates
      templates = {
        python = {
          path = ./devFlakes/python;
          description = "Python development environment with data science tools";
        };

        rust = {
          path = ./devFlakes/rust;
          description = "Rust development environment with rust-analyzer";
        };

        go = {
          path = ./devFlakes/go;
          description = "Go development environment with gopls";
        };

        java = {
          path = ./devFlakes/java;
          description = "Java development environment with Maven and Gradle";
        };

        kotlin = {
          path = ./devFlakes/kotlin;
          description = "Kotlin development environment";
        };

        c = {
          path = ./devFlakes/c;
          description = "C/C++ development environment with GCC and Clang";
        };

      };
    };
}
