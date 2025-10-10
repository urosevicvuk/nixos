{
  description = "C/C++ development environment";

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
            gcc
            clang
            cmake
            gnumake
            gdb
            valgrind
            clang-tools
            ccls
          ];

          shellHook = ''
            echo "C/C++ development environment"
            echo "GCC version: $(gcc --version | head -n 1)"
            echo "Clang version: $(clang --version | head -n 1)"
          '';
        };
      }
    );
}
