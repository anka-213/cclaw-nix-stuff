{ sources ? import nix/sources.nix }:

let
  newpkgs = import sources.nixpkgs {
    overlays = [
      (import gf/overlay.nix { inherit sources; })
      (
        nixpkgs: pkgssuper: {
          # inherit (import ./gf-core.nix {inherit nixpkgs sources; }) gf;
          gf = pkgssuper.haskell.lib.justStaticExecutables (nixpkgs.haskellPackages.gf-core);
          # gf-rgl = import ./build-gf-rgl.nix {inherit nixpkgs ; };
          gf-rgl = nixpkgs.callPackage ./gf-rgl.nix { inherit sources; };
          bnfc = pkgssuper.haskell.lib.justStaticExecutables (
            nixpkgs.haskellPackages.callCabal2nix "bnfc" (sources.bnfc + "/source") {}
          );
          gf-with-rgl = nixpkgs.callPackage ./gf-with-rgl.nix {};
        }
      )
    ];
  };
in
{
  inherit (newpkgs) gf gf-rgl bnfc gf-pgf gf-with-rgl;
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
