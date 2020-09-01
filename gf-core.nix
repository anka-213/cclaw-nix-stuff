{ buildEnv }:
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
      sha256 = "0bwfb3zhn7i33rs90sddqccmq04hghjm0hlqqh6dmq5k5n7k8n6g";
    };
    in
    {
      gf = onlyBin (import gf-core { });

    }
