{ nixpkgs ? import <nixpkgs> {} }:

{
  gf-rgl = import ./build-gf-rgl.nix {};
  bnfc = import ./install-bnfc.nix {};
}
