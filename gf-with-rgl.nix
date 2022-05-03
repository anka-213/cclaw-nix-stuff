{ gf
, gf-rgl
, makeWrapper
, runCommandLocal
}:


runCommandLocal
  (gf.name + "-with-rgl")
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
      --suffix GF_LIB_PATH : ${gf-rgl}/share/gf/lib
  ''
