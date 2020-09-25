{ src, stdenvNoCC, gf, gf-rgl, ninja }:

stdenvNoCC.mkDerivation {
  name = "gf-wordnet";
  inherit src;
  buildInputs = [ ninja ];
  GF_LIB_PATH = "${gf-rgl}/rgl";

  my_ninjaHeader = ''
    build_dir = build/gfo
    gf_flags = --batch --quiet --gfo-dir=$build_dir

    rule gf
      command = ${gf}/bin/gf $gf_flags $in

    build $build_dir/WordNet.gfo: gf WordNet.gf
  '';

  # gf_flags = --batch --quiet --gf-lib-path=${gf-rgl}/rgl --gfo-dir=$build_dir
  preBuild = ''
    echo "$my_ninjaHeader" > build.ninja

    for lang in Eng Swe Spa Chi; do
      echo "build \$build_dir/WordNet$lang.gfo: gf WordNet$lang.gf \$build_dir/WordNet.gfo" >> build.ninja
    done
  '';

  installPhase = ''
    mkdir $out
    mv build/gfo/WordNet*.gfo $out/
  '';
}
