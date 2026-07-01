{
  description = "Python with llvmlite";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages (python-pkgs: [ python-pkgs.llvmlite ]))
          ];
        };
        packages.default = pkgs.python3Packages.buildPythonApplication {
          pname = "graph-llvm-ir";
          version = "unstable-${self.shortRev or self.dirtyShortRev}";
          src = self;
          format = "other";
          installPhase = ''
            mkdir -p $out/bin
            cp graph-llvm-ir $out/bin/
          '';
          propagatedBuildInputs = [
            (pkgs.python3.withPackages (python-pkgs: [ python-pkgs.llvmlite ]))
          ];
        };
      }
    );
}
