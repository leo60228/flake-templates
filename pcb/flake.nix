{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  inputs.nixpkgsUnstable.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, nixpkgsUnstable, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = {
          kicad-unstable = with pkgs; let
            kicad = callPackage "${nixpkgsUnstable}/pkgs/applications/science/electronics/kicad" {
              pname = "kicad-unstable";
              stable = false;
              srcs = {
                kicadVersion = "2021-02-22";
                kicad = fetchFromGitLab {
                  group = "kicad";
                  owner = "code";
                  repo = "kicad";
                  rev = "c1aa50e5222d708fa8a86c075472b5f92d484aba";
                  sha256 = "1m83skcxb2l4cgd4r7dxjc251v768ikjpvmzwsx5yk5qz0ck6zyx";
                };
                libVersion = "2021-02-22";
                i18n = fetchFromGitLab {
                  group = "kicad";
                  owner = "code";
                  repo = "kicad-i18n";
                  rev = "e89d9a89bec59199c1ade56ee2556591412ab7b0";
                  sha256 = "04zaqyhj3qr4ymyd3k5vjpcna64j8klpsygcgjcv29s3rdi8glfl";
                };
                symbols = fetchFromGitLab {
                  group = "kicad";
                  owner = "libraries";
                  repo = "kicad-symbols";
                  rev = "12edec9499b0d470de14ceb68226accb29d6355a";
                  sha256 = "181bj748h3gcs7f0006z4v3yml319yc96i3zwpbqxl5frjynrkwy";
                };
                templates = fetchFromGitLab {
                  group = "kicad";
                  owner = "libraries";
                  repo = "kicad-templates";
                  rev = "073d1941c428242a563dcb5301ff5c7479fe9c71";
                  sha256 = "14p06m2zvlzzz2w74y83f2zml7mgv5dhy2nyfkpblanxawrzxv1x";
                };
                footprints = fetchFromGitLab {
                  group = "kicad";
                  owner = "libraries";
                  repo = "kicad-footprints";
                  rev = "964e997877b61806cb800d97e360a6c1bc5fab52";
                  sha256 = "0i7f40mcwd90b447x64fb58xnpfvn08ai59sg5nm2rbp623dqpvp";
                };
                packages3d = fetchFromGitLab {
                  group = "kicad";
                  owner = "libraries";
                  repo = "kicad-packages3d";
                  rev = "d8b7e8c56d535f4d7e46373bf24c754a8403da1f";
                  sha256 = "0dh8ixg0w43wzj5h3164dz6l1vl4llwxhi3qcdgj1lgvrs28aywd";
                };
              };
            };
            inherit (kicad.libraries) packages3d footprints;
          in
            kicad.overrideAttrs (oldAttrs: {
              makeWrapperArgs = (builtins.map (builtins.replaceStrings [ "KICAD_" ] [ "KICAD6_" ]) oldAttrs.makeWrapperArgs) ++ [
                "--set-default KICAD6_3DMODEL_DIR ${packages3d}/share/kicad/3dmodels"
                "--set-default KICAD6_FOOTPRINT_DIR ${footprints}/share/kicad/modules"
              ];
            });
          freecad = with pkgs; freecad.overrideAttrs (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ (with python3Packages; [ ply ]);
          });
        };
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; with packages; [ kicad-unstable gerbv freecad blender python3 ];
          buildInputs = with pkgs; with python3Packages; with packages; [ pip setuptools (toPythonModule kicad-unstable.src) ];
        };
      }
    );
}
