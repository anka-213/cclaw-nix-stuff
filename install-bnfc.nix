{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;
let
  url = "https://github.com/BNFC/bnfc.git";
  sha256 = "0gkg2lqd3bln518wvsfv7gza44p6j2jrpnwy75pmzkwmkspd5y60";
  source = fetchgit { inherit url sha256; } + "/source";
in
haskellPackages.callCabal2nix "package-name" (source) {}
