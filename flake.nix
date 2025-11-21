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
      url = "github:abenz1267/elephant";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
    };

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence - not imported yet, for review
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # Disko - declarative disk partitioning - not imported yet, for review
    disko = {
      url = "github:nix-community/disko";
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
            inputs.lanzaboote.nixosModules.lanzaboote
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
              ];
            }
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.lanzaboote.nixosModules.lanzaboote
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
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-minecraft.nixosModules.minecraft-servers
            # inputs.nixarr.nixosModules.default  # Enable when nixarr input is added and configured
            # inputs.search-nixos-api.nixosModules.search-nixos-api  # Enable when search-nixos-api input is added
            ./hosts/firelink/configuration.nix
          ];
        };
      };
    };
}
