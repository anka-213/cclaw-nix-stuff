{ pkgs, sources }:
with pkgs.haskell.lib;
let
  haskellPackages = pkgs.haskellPackages.override {
    overrides = haskellPackagesNew: _haskellPackagesOld:
      {
        # site = haskellPackagesNew.callPackage ./site.nix {};
        # gf-core = overrideCabal (haskellPackagesNew.callPackage ./gf-core.nix {}) (old: {
        gf-core = overrideCabal (haskellPackagesNew.callCabal2nix "gf" sources.gf-core { }) (
          _old: {
            # Fix utf8 encoding problems
            patches = [
              (
                pkgs.fetchpatch {
                  url = "https://github.com/anka-213/gf-core/commit/6f1ca05fddbcbc860898ddf10a557b513dfafc18.patch";
                  sha256 = "17vn3hncxm1dwbgpfmrl6gk6wljz3r28j191lpv5zx741pmzgbnm";
                }
              )
            ];
            configureFlags = "-f c-runtime ";
            # jailbreak = true; # jailbreak dependecies
            librarySystemDepends = [ gf-pgf ];
          }
        );
        # gf-core = haskellPackagesNew.callPackage ./gf-core-c.nix {};
        # gf-c-bindings = haskellPackagesNew.callPackage ./haskell-bind.nix {};
        gf-c-bindings = overrideCabal
          (
            haskellPackagesNew.callCabal2nix "pgf2"
              (sources.gf-core + "/src/runtime/haskell-bind") { gu = null; pgf = null; }
          )
          (
            _old: {
              librarySystemDepends = [ gf-pgf ];
            }
          );
      };
  };
  gf-pgf = pkgs.callPackage gf/c-runtime.nix { inherit gf-core; };
in
{
  inherit haskellPackages gf-pgf;
}
