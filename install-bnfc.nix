{ haskellPackages, sources }:
haskellPackages.callCabal2nix "bnfc" (sources.bnfc + "/source") {}
