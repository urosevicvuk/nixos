{
  description = "Java development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk21
            maven
            gradle
            jdt-language-server
          ];

          shellHook = ''
            echo "Java development environment"
            echo "Java version: $(java -version 2>&1 | head -n 1)"
            echo "Maven version: $(mvn --version | head -n 1)"
          '';
        };
      }
    );
}
