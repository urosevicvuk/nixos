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

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
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

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-stable, ... }:
    {
      # NixOS configurations:w
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
            }
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/ariandel/configuration.nix
          ];
        };

        # fireLink is the server
        fireLink = nixpkgs.lib.nixosSystem {
          modules = [
            { _module.args = { inherit inputs; }; }
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.sops-nix.nixosModules.sops
            inputs.nixarr.nixosModules.default
            inputs.search-nixos-api.nixosModules.search-nixos-api
            ./hosts/fireLink/configuration.nix
          ];
        };
      };
    };
}
