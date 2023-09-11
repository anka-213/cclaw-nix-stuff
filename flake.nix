{
  description = "A flake for GrammaticalFramework (and bnfc)";

  # inputs.gf-overlay.url = "./gf/flake-overlay.nix";
  inputs = {
    # nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;
    nixpkgs.url = "nixpkgs"; # = nixpkgs-unstable
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
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      # systems = [ "x86_64-darwin" ];
      # forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        }
      );
      ghc-version = "ghc8107";

      sources = { inherit bnfc gf-core gf-rgl gf-wordnet; };
      gf-overlay = import gf/overlay.nix { inherit sources ghc-version; };

      my-overlay = final: prev:
        let
          inherit (prev.haskell.lib) justStaticExecutables;
          # inherit (final.haskellPackages) justStaticExecutables;
        in
        {
          bnfc = justStaticExecutables (
            final.haskellPackages.callCabal2nix "bnfc" (sources.bnfc + "/source") { }
          );
          # inherit (import ./gf-core.nix {inherit nixpkgs sources; }) gf;
          gf-core = justStaticExecutables (final.haskellPackages.gf-core);
          # gf-rgl = import ./build-gf-rgl.nix {inherit final ; };
          gf-rgl = final.callPackage ./gf-rgl.nix { inherit sources; };
          gf-wordnet = final.callPackage ./gf-wordnet.nix { src = sources.gf-wordnet; };
          gf-with-rgl = final.callPackage ./gf-with-rgl.nix { };
          gf-with-rgl-and-wordnet = final.callPackage ./gf-with-rgl-and-wordnet.nix { };
        };
    in
    {

      overlays = {
        gf-overlay = gf-overlay;
        my-overlay = my-overlay;
      };

      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) gf-core gf-with-rgl gf-rgl bnfc gf-wordnet gf-with-rgl-and-wordnet gf-python-runtime;
        pythonWithPGF = nixpkgsFor.${system}.python3.withPackages(ps: [ps.gf-pgf]);
      });

      legacyPackages = forAllSystems (system: {
        # Python-version including gf-pgf
        # Allows making ad-hoc environments like this:
        # nix shell \
        #     --impure \
        #     --expr "with builtins; with getFlake (toString ./.); (getAttr currentSystem legacyPackages).python3.withPackages (ps: with ps; [ gf-pgf gnureadline ])"
        # And similarly for haskell packages:
        # nix shell \
        #     --impure \
        #     --expr "with builtins; with getFlake (toString ./.); (getAttr currentSystem legacyPackages).haskellPackages.ghcWithPackages (ps: with ps; [ gf-core gf-c-bindings ])"
        # Replace (toString ./.) with "github:anka-213/cclaw-nix-stuff/nix-flakes" to use the version from github instead of the local directory
        # or "github:anka-213/cclaw-nix-stuff/some-git-commit-hash" to use a specific git commit version
        inherit (nixpkgsFor.${system}) python3 haskellPackages;
      });

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

    nixConfig = {
      extra-substituters = [ "https://cclaw.cachix.org" ];
      extra-trusted-public-keys = [ "cclaw.cachix.org-1:uBByGxyttKSKDJyN97r1MkfMA9SYv2ENOHKh1YgjGKU=" ];
      allow-import-from-derivation = "true";
    };
}
