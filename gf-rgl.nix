{ sources, stdenv, ghc, gf-core }:

stdenv.mkDerivation {
  name = "gf-rgl";
  # src = ./.;
  buildInputs = [ ghc gf-core ];
  # doc requirements: [graphviz-nox]
  src = sources.gf-rgl;
  # Keep references to source, so go to definition works
  postUnpack = ''
    rm -r source/src
    ln -s $src/src source/src
  '';
  buildPhase = ''
    export LC_ALL="C.UTF-8"
    runghc Setup.hs build
  '';
  installPhase = ''
    export LC_ALL="C.UTF-8"
    mkdir -p $out/share/gf/lib
    runghc Setup.hs copy --dest=$out/share/gf/lib
  '';

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
