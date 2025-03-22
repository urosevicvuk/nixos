{ inputs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "idkbackup";
    extraSpecialArgs = { inherit inputs; };
  };
}
