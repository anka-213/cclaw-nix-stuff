{ gf-core
, gf-rgl
, makeWrapper
, runCommandLocal
}:


runCommandLocal
  (gf-core.name + "-with-rgl")
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
      --suffix GF_LIB_PATH : ${gf-rgl}/share/gf/lib
  ''
