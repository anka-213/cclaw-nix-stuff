{ sources ? import nix/sources.nix }:

let
  inherit (import sources.nixpkgs {}) pkgs;
in
pkgs.mkShell {
  buildInputs = [ pkgs.nix-build-uncached ];
}
