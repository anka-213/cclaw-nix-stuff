{ sources ? import nix/sources.nix }:

let
  newpkgs = import sources.nixpkgs { overlays = [ (nixpkgs: pkgssuper: {
    inherit (import ./gf-core.nix {inherit nixpkgs sources; }) gf;
    # gf-rgl = import ./build-gf-rgl.nix {inherit nixpkgs ; };
    gf-rgl = nixpkgs.callPackage ./gf-rgl.nix { inherit sources; };
    bnfc = nixpkgs.haskellPackages.callCabal2nix "bnfc" (sources.bnfc + "/source") {};
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
