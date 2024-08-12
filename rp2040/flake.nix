{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.segger-jlink.acceptLicense = true;
          overlays = [ (self: super: { pico-sdk = super.pico-sdk.override { withSubmodules = true; }; }) ];
        };
        shell =
          {
            mkShell,
            pkgsCross,
            cmake,
            pico-sdk,
            picotool,
            segger-jlink-headless,
          }:
          mkShell {
            packages = [
              cmake
              pkgsCross.arm-embedded.stdenv.cc
              pico-sdk
              picotool
              segger-jlink-headless
            ];

            hardeningDisable = [ "format" "stackprotector" "pic" "relro" "zerocallusedregs" ];

            shellHook = ''
              export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk
            '';
          };
      in
      {
        devShell = pkgs.callPackage shell { };
      }
    );
}
