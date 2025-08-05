{
  description = "PSn00bSDK flake for PS1 development";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgsMipsel = import nixpkgs {
          inherit system;
          crossSystem = {
            config = "mipsel-none-elf";
            libc = "newlib";
            gcc = {
              abi = "32";
              arch = "mips1";
            };
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              mipsel-embedded = pkgsMipsel;
            })
          ];
        };
        psn00bsdk = pkgs.callPackage ./psn00bsdk.nix {};
      in {
        inherit pkgs;
        inherit psn00bsdk;
        default = psn00bsdk;
        n00bdemo = pkgsMipsel.callPackage ./n00bdemo { inherit psn00bsdk; };
      }
    );

    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = self.packages.${system}.pkgs;
        psn00bsdk = self.packages.${system}.psn00bsdk;
      in {
        default = pkgs.mkShell {
          buildInputs = [
            psn00bsdk
            pkgs.cmake
            pkgs.gnumake
            pkgs.ninja
            pkgs.mipsel-embedded.buildPackages.gcc
            pkgs.mipsel-embedded.buildPackages.binutils
            pkgs.gcc
            pkgs.binutils
          ];

          shellHook = ''
            export CC=mipsel-none-elf-nolibc-gcc
            export CXX=mipsel-none-elf-nolibc-g++
            export PSN00BSDK_PATH=${psn00bsdk}
            echo "PSn00bSDK dev shell ready. Cross compile with mipsel-none-elf-nolibc-gcc"
          '';
        };
      }
    );
  };
}
