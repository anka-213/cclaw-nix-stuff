{ nixpkgs, sources }:
let
  #   onlyBin = pkg: nixpkgs.buildEnv {
  #     name = "${pkg.name}";
  #     paths = [ pkg ];
  #     pathsToLink = [ "/bin" "/share" ];
  #   };
  gf-core = sources.gf-core;
in
{
  gf = nixpkgs.haskell.lib.justStaticExecutables (import gf-core { inherit nixpkgs; });

}
