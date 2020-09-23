{ sources ? import ../nix/sources.nix }:
pkgs: oldpkgs: {
  haskellPackages = oldpkgs.haskellPackages.override {
    overrides = haskellPackagesNew: _haskellPackagesOld:
      with oldpkgs.haskell.lib;
      {
        # site = haskellPackagesNew.callPackage ./site.nix {};
        # gf-core = overrideCabal (haskellPackagesNew.callPackage ./gf-core.nix {}) (old: {
        gf-core = overrideCabal (haskellPackagesNew.callCabal2nix "gf" sources.gf-core {}) (
          _old: {
            # Fix utf8 encoding problems
            # patches = [(
            #   oldpkgs.fetchpatch {
            #     url = "https://github.com/anka-213/gf-core/commit/6f1ca05fddbcbc860898ddf10a557b513dfafc18.patch";
            #     sha256 = "17vn3hncxm1dwbgpfmrl6gk6wljz3r28j191lpv5zx741pmzgbnm";
            #   }
            # )];
            configureFlags = "-f c-runtime";
            # jailbreak = true; # jailbreak dependecies
            librarySystemDepends = [ pkgs.gf-pgf ];
          }
        );
        # gf-core = haskellPackagesNew.callPackage ./gf-core-c.nix {};
        # gf-c-bindings = haskellPackagesNew.callPackage ./haskell-bind.nix {};
        gf-c-bindings = overrideCabal (haskellPackagesNew.callPackage ./haskell-bind.nix { gu = null; pgf = null; }) (
          _old: {
            librarySystemDepends = [ pkgs.gf-pgf ];
          }
        );
      };
  };
  gf-pgf = pkgs.callPackage ./c-runtime.nix {};
}
