{ gf-core
, gf-rgl
, gf-wordnet
, makeWrapper
, runCommandLocal
}:

# TODO: Make a generic wrapper for any combination of libs
runCommandLocal
  (gf-core.name + "-with-rgl-and-wordnet")
{

  passthru = {
    preferLocalBuild = true;
    inherit (gf-core) version meta;
  };
}
  ''
    . ${makeWrapper}/nix-support/setup-hook

    prg=gf
    makeWrapper ${gf-core}/bin/$prg $out/bin/$prg \
      --suffix GF_LIB_PATH : ${gf-rgl}/share/gf/lib:${gf-wordnet}/share/gf/lib
  ''
