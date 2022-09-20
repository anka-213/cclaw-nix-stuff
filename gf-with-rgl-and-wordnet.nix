{ gf
, gf-rgl
, gf-wordnet
, makeWrapper
, runCommandLocal
}:

# TODO: Make a generic wrapper for any combination of libs
runCommandLocal
  (gf.name + "-with-rgl-and-wordnet")
{

  passthru = {
    preferLocalBuild = true;
    inherit (gf) version meta;
  };
}
  ''
    . ${makeWrapper}/nix-support/setup-hook

    prg=gf
    makeWrapper ${gf}/bin/$prg $out/bin/$prg \
      --suffix GF_LIB_PATH : ${gf-rgl}/share/gf/lib:${gf-wordnet}/share/gf/lib
  ''
