{
  description = "Kotlin development environment";

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
            kotlin
            kotlin-language-server
            gradle
            maven
          ];

          shellHook = ''
            echo "Kotlin development environment"
            echo "Kotlin version: $(kotlin -version 2>&1)"
            echo "Java version: $(java -version 2>&1 | head -n 1)"
          '';
        };
      }
    );
}
