{ nixpkgs ? import <nixpkgs> {} }:

# Todo: use some better overlay pattern instead
rec {
  gf-rgl = import ./build-gf-rgl.nix {};
  bnfc = import ./install-bnfc.nix {};
  gf = (import ./install-bnfc.nix {}).gf;
}
