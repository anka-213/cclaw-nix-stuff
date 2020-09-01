{ nixpkgs ? import <nixpkgs> {} }:

# Todo: use some better overlay pattern instead
let
  inherit (import ./install-bnfc.nix {}) gf;
in
{
  gf-rgl = import ./build-gf-rgl.nix {};
  bnfc = import ./install-bnfc.nix {};
  inherit gf;
}
