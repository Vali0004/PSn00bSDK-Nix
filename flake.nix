{
  description = "PSn00bSDK flake for PS1 development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pcsx-redux.url = "github:cleverca22/pcsx-redux/fix-submodules";
  };

  outputs = { self, nixpkgs, pcsx-redux }: {
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
      self_packages = self.packages.${system};
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = {
        type = "app";
        program = "${self_packages.runDemo}/bin/runDemo";
      };
      pcsx-redux = let
        script = pkgs.writeShellScript "pcsx-redux" ''
          ${pcsx-redux.packages.${system}.default}/bin/pcsx-redux -loadexe ${self.packages.${system}.n00bdemo}/n00bdemo.exe -run
        '';
      in {
        type = "app";
        program = "${script}";
      };
    });

    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      default = self.packages.${system}.n00bdemo;
    });
  };
}
