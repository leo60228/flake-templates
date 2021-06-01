{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-rp2040.url = "github:leo60228/nix-rp2040";
  inputs.nix-jlink.url = "github:leo60228/nix-jlink";

  outputs = { nixpkgs, flake-utils, nix-rp2040, nix-jlink, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (nix-rp2040.packages.${system}) pico-sdk;
        inherit (nix-jlink.packages.${system}) jlink;
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ gcc-arm-embedded cmake jlink ];
          buildInputs = [ pico-sdk ];
        };
      }
    );
}
