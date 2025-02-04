{
  description = "Minecraft Speedrunning Stronghold Calculator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux"];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

          packages.default = pkgs.callPackage ./package.nix {};

          apps.default = { 
              type = "app";
              program = self'.packages.default;
          };

      };
      flake = { };
    };
}

