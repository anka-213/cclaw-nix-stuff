{ nixpkgs ? import <nixpkgs> {} }:
# let
#   inherit (nixpkgs) pkgs;
# in
nixpkgs.callPackage ./gf-rgl.nix { }
