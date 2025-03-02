{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake";

    hyprland-plugins = {
    	url = "github:hyprwm/hyprland-plugins";
	inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "vukNixOS";
      username = "vuk23";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs username host;
          };
          modules = [
            ./hosts/${host}/configuration.nix
            #./modules/nixos
            inputs.stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit system inputs username host;
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users."${username}" = {
                imports = [
                  ./hosts/${host}/home.nix
                  #./modules/home-manager
                ];
              };
            }
          ];
        };
      };
    };
}
