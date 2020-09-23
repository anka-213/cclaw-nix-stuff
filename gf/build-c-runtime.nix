{ nixpkgs ? import <nixpkgs> {} }:
nixpkgs.pkgs.callPackage ./c-runtime.nix {}
