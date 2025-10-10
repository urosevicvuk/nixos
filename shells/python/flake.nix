{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Core data science
          numpy
          pandas
          scipy
          matplotlib
          seaborn

          # Dev tools
          ipython
          jupyter
          black
          pylint
          pytest

          # Add your project-specific packages here
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            python3Packages.python-lsp-server
            ruff
          ];

          shellHook = ''
            echo "Python development environment"
            echo "Python version: $(python --version)"
          '';
        };
      }
    );
}
