{ nixpkgs ? import <nixpkgs> {} }:
    let
    onlyBin = pkg: nixpkgs.buildEnv {
      name = "${pkg.name}";
      paths = [pkg];
      pathsToLink = [ "/bin" "/share" ];
    };
    gf-core = fetchTarball {
      # Insert the desired all-hies commit here
      url = "https://github.com/anka-213/gf-core/archive/nix-support.tar.gz";
      # Insert the correct hash after the first evaluation
      sha256 = "1gxaxbkb98xl4mlxs9i8sykcgyvjw2zv3l9whzvzvxwwhwj2jn0k";
    };
    in
    {
      gf = onlyBin (import gf-core { });

    }
