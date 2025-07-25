{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy simplifies and unifies the Hyprland ecosystem with a modular, easily customizable setup.
    It provides a structured way to manage your system configuration and dotfiles with minimal effort.
  '';

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/25.05";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
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

    #    nixcord = {
    #      url = "github:kaylorben/nixcord"; # Discord client for NixOS
    #    };

    sops-nix = {
      url = "github:Mic92/sops-nix"; # SOPS integration for NixOS
    };

    #    nixarr = {
    #      url = "github:rasmus-kirk/nixarr";
    #    };

    anyrun = {
      url = "github:fufexan/anyrun/launch-prefix";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #search-nixos-api = {
    #  url = "github:anotherhadi/search-nixos-api";
    #};
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
