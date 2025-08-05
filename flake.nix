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
        n00bdemo = pkgsMipsel.callPackage ./n00bdemo { inherit psn00bsdk; };
      in {
        inherit psn00bsdk n00bdemo;
        runDemo = pkgs.writeShellScriptBin "runDemo" ''
          ${pkgs.duckstation}/bin/duckstation-qt ${n00bdemo}/n00bdemo.exe -fastboot
        '';
        default = n00bdemo;
      }
    );

    apps = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: let
      pkgs = self.packages.${system};
    in {
      default = {
        type = "app";
        program = "${pkgs.runDemo}/bin/runDemo";
      };
    });

    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      default = self.packages.${system}.n00bdemo;
    });
  };
}
