{ sources ? import nix/sources.nix }:

let
  newpkgs = import sources.nixpkgs { overlays = [ (nixpkgs: pkgssuper: {
    # python27 = let
    #   packageOverrides = self: super: {
    #     numpy = super.numpy_1_10;
    #   };
    # in pkgssuper.python27.override {inherit packageOverrides;};
    inherit (import ./gf-core-overlay.nix {inherit nixpkgs sources; }) gf;
    gf-rgl = import ./build-gf-rgl.nix {inherit nixpkgs ; };
    bnfc = import ./install-bnfc.nix {inherit nixpkgs ; };
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
