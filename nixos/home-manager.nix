{ inputs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbackup";
    extraSpecialArgs = { inherit inputs; };
  };
}
