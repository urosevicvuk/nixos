{ inputs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "ajdevise";
    extraSpecialArgs = { inherit inputs; };
  };
}
