{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc883" }:
let
  pgf = import ./build-c-runtime.nix { inherit nixpkgs; };
in
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./haskell-bind.nix
  {
    inherit pgf;
  }
