{ gf
, gf-rgl
, makeWrapper
, symlinkJoin
}:


symlinkJoin {
  name = gf.name + "-with-rgl";
  paths = [ gf ];
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    prg=gf
    rm -f $out/bin/$prg
    makeWrapper ${gf}/bin/$prg $out/bin/$prg \
      --suffix GF_LIB_PATH : ${gf-rgl}/rgl
  '';

  passthru = {
    preferLocalBuild = true;
    inherit (gf) version meta;
  };
}
