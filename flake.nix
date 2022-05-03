{
  description = "A flake for GrammaticalFramework (and bnfc)";

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
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      # systems = [ "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        }
      );

      sources = { inherit bnfc gf-core gf-rgl gf-wordnet; };
      gf-overlay = import gf/overlay.nix { inherit sources; };

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
          gf = justStaticExecutables (final.haskellPackages.gf-core);
          # gf-rgl = import ./build-gf-rgl.nix {inherit final ; };
          gf-rgl = final.callPackage ./gf-rgl.nix { inherit sources; };
          gf-wordnet = final.callPackage ./gf-wordnet.nix { src = sources.gf-wordnet; };
          gf-with-rgl = final.callPackage ./gf-with-rgl.nix { };
        };
    in
    {

      overlays = {
        gf-overlay = gf-overlay;
        my-overlay = my-overlay;
      };

      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) gf-with-rgl gf-rgl bnfc gf-wordnet;
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
}
