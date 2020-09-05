{ nixpkgs, sources }:
    let
    onlyBin = pkg: nixpkgs.buildEnv {
      name = "${pkg.name}";
      paths = [pkg];
      pathsToLink = [ "/bin" "/share" ];
    };
    gf-core = sources.gf-core;
    in
    {
      gf = onlyBin (import gf-core { });

    }
