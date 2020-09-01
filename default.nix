{ nixpkgs ? import <nixpkgs> {} }:

let
  pkgs = import <nixpkgs> {};
  newpkgs = import pkgs.path { overlays = [ (pkgsself: pkgssuper: {
    # python27 = let
    #   packageOverrides = self: super: {
    #     numpy = super.numpy_1_10;
    #   };
    # in pkgssuper.python27.override {inherit packageOverrides;};
    inherit (import ./gf-core-overlay.nix {nixpkgs = pkgsself; }) gf;
    gf-rgl = import ./build-gf-rgl.nix {nixpkgs = pkgsself; };
    bnfc = import ./install-bnfc.nix {nixpkgs = pkgsself; };
  } ) ]; };
in
  {
    inherit (newpkgs) gf gf-rgl bnfc;
  }

# # Todo: use some better overlay pattern instead
# let
#   inherit (import ./install-bnfc.nix {}) gf;
# in
# {
#   gf-rgl = import ./build-gf-rgl.nix {};
#   bnfc = import ./install-bnfc.nix {};
#   inherit gf;
# }
