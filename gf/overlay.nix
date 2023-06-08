{ sources ? import ../nix/sources.nix , ghc-version ? "ghc8107"}:
final: prev: {
  haskellPackages = prev.haskell.packages.${ghc-version}.override {
    overrides = haskellPackagesNew: _haskellPackagesOld:
      with prev.haskell.lib;
      {
        # site = haskellPackagesNew.callPackage ./site.nix {};
        # gf-core = overrideCabal (haskellPackagesNew.callPackage ./gf-core.nix {}) (old: {
        gf-core = overrideCabal (haskellPackagesNew.callCabal2nix "gf" sources.gf-core {}) (
          _old: {
            # Fix utf8 encoding problems
            patches = [
              # (
              #   prev.fetchpatch {
              #     url = "https://github.com/anka-213/gf-core/commit/6f1ca05fddbcbc860898ddf10a557b513dfafc18.patch";
              #     sha256 = "17vn3hncxm1dwbgpfmrl6gk6wljz3r28j191lpv5zx741pmzgbnm";
              #   }
              # )
              # ./encoding-fix.patch # Already applied to latest gf-core/master
              ./revert-new-cabal-madness.patch
            ];
            configureFlags = "-f c-runtime";
            # jailbreak = true; # jailbreak dependecies
            librarySystemDepends = [ final.gf-pgf ];
          }
        );
        # gf-core = haskellPackagesNew.callPackage ./gf-core-c.nix {};
        # gf-c-bindings = haskellPackagesNew.callPackage ./haskell-bind.nix {};
        gf-c-bindings = overrideCabal (
          haskellPackagesNew.callCabal2nix "pgf2" (sources.gf-core + "/src/runtime/haskell-bind")
            { gu = null; pgf = null; }
        )
          (
            _old: {
              librarySystemDepends = [ final.gf-pgf ];
            }
          );
      };
  };
  gf-pgf = final.callPackage ./c-runtime.nix { inherit (sources) gf-core; };
  gf-python-runtime = final.callPackage ./gf-python-runtime.nix { inherit (sources) gf-core; };
}
