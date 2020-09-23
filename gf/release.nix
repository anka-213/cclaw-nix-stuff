let
  myOverlay = import ./overlay.nix;

  pkgs = import <nixpkgs> { overlays = [ (myOverlay {}) ]; };
  # in pkgs.haskellPackages.gf-core
  # in pkgs.asdfasdf
in
{
  inherit (pkgs) gf-pgf;
  inherit (pkgs.haskellPackages) gf-core gf-c-bindings;
}
