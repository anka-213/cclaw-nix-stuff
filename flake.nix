{
  description = "A very basic flake";

  # inputs.gf-overlay.url = "./gf/flake-overlay.nix";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;
    # nixpkgs.overlay = gf/overlay.nix;
    # nixpkgs.overlay = "gf/overlay.nix";
    bnfc.url = github:BNFC/bnfc/master;
    bnfc.flake = false;
    gf-core.url = github:GrammaticalFramework/gf-core/master;
    gf-core.flake = false;
    gf-rgl.url = github:GrammaticalFramework/gf-rgl/master;
    gf-rgl.flake = false;
    gf-wordnet.url = github:GrammaticalFramework/gf-wordnet/master;
    gf-wordnet.flake = false;
  };

  # overlay.nixpkgs = "foo";

  outputs = { self, nixpkgs, bnfc, gf-core, gf-rgl, gf-wordnet }:
    let
      sources = { inherit bnfc gf-core gf-rgl gf-wordnet; };
      overlay = import gf/overlay.nix { inherit sources; };

      pkgs1 = import nixpkgs { overlays = [ overlay ]; };
    in
    {

      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

      packages = builtins.mapAttrs
        (_: pkgs:
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
          rec {
            bnfc = justStaticExecutables (
              pkgs.haskellPackages.callCabal2nix "bnfc" (sources.bnfc + "/source") { }
            );
            gf = justStaticExecutables (haskellPackages.gf-core);
            gf-rgl = pkgs.callPackage ./gf-rgl.nix { inherit sources; };
            gf-wordnet = pkgs.callPackage ./gf-wordnet.nix { src = sources.gf-wordnet; };
            gf-with-rgl = pkgs.callPackage ./gf-with-rgl.nix { };
          })
        nixpkgs.legacyPackages;

      # defaultPackage = builtins.mapAttrs (_: pkgs: pkgs.lambda-launcher) self.packages;

      # defaultApp = builtins.mapAttrs (_: pkg: {
      #   type = "app";
      #   program = "${pkg}/bin/lambda-launcher";
      # }) self.defaultPackage;

      # devShell = builtins.mapAttrs (arch: pkgs: pkgs.mkShell {
      #   # inputsFrom = [ self.packages.${arch}.lambda-launcher-unwrapped self.packages.${arch}.lambda-launcher ];
      #   # inputsFrom = [ self.packages.${arch}.lambda-launcher ];
      #   # buildInputs = [ self.packages.${arch}.haskell-language-server ];
      #   buildInputs = [ self.packages.${arch}.ghc-wrapper ];
      #   shellHook = "eval $(egrep ^export ${self.packages.${arch}.ghc-wrapper}/bin/ghc)";
      #   # shellHook = "eval $(egrep ^export ${pkgs.ghc-wrapper}/bin/ghc)";
      # }) nixpkgs.legacyPackages;

    };
}
