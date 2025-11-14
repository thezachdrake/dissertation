{
  description = "Dev shell for the dissertation project with Julia and system libraries";

  inputs = {
    # Pin to the 25.05 stable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            julia
            # System libraries needed for Julia numerical packages
            gcc-unwrapped.lib # Provides libquadmath.so.0
            glibc
            stdenv.cc.cc.lib
            gfortran.cc.lib
            blas
            lapack
          ];

          # Environment variables that direnv will use
          env = {
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (
              with pkgs;
              [
                gcc-unwrapped.lib
                glibc
                stdenv.cc.cc.lib
                gfortran.cc.lib
                blas
                lapack
              ]
            )}";
            JULIA_PROJECT = "@.";
            JULIA_DEPOT_PATH = ".julia";
            # Add Julia project binaries to PATH
            PATH = "$PWD/.julia/bin:$PATH";
          };

          shellHook = ''
            echo "Using $(julia --version)"
            echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
            echo "Julia project: $JULIA_PROJECT"
            echo "Julia depot: $JULIA_DEPOT_PATH"

            # Add Julia project binaries to PATH (e.g., jlfmt from JuliaFormatter)
            export PATH="$PWD/.julia/bin:$PATH"

            # Create local Julia depot directory if it doesn't exist
            mkdir -p .julia

            # Instantiate the project packages
            echo "Instantiating Julia project..."
            julia --project=. -e "using Pkg; Pkg.instantiate()"
          '';
        };
      });
    };
}
