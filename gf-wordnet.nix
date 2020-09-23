{ src, stdenv, ghc, gf, gf-rgl, gf-pgf }:

stdenv.mkDerivation {
  name = "gf-wordnet";
  enableParallelBuildings = true;
  # src = ./.;
  buildInputs = [ ghc gf gf-pgf ];
  inherit src;
  preBuild = ''
    mkdir $out
    for f in ${gf-rgl}/rgl/*; do
      # TODO: This is a hack. We shouldn't put rgl in our out
      ln -s $f $out/
      # ln -s $f ./
    done
    export GF_LIB_PATH=$out
  '';
  # buildPhase = ''
  #   runghc Setup.hs build
  # '';
  # installPhase = ''
  #   mkdir -p $out/rgl
  #   runghc Setup.hs copy --dest=$out/rgl
  # '';

}
# RUNMAKE=runghc Setup.hs

# .PHONY: build copy install doc clean

# default: build copy

# build: src/*/*.gf
#   $(RUNMAKE) build

# copy:
#   $(RUNMAKE) copy

# install: build copy

# doc: build
#   make -C doc GF_LIB_PATH=../dist
