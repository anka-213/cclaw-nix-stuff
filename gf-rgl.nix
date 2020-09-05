{ sources, stdenv, ghc, gf }:

stdenv.mkDerivation {
  name = "gf-rgl";
  # src = ./.;
  buildInputs = [ghc gf];
  # doc requirements: [graphviz-nox]
  src = sources.gf-rgl;
  buildPhase = ''
    runghc Setup.hs build
  '';
  installPhase = ''
    mkdir -p $out/rgl
    runghc Setup.hs copy --dest=$out/rgl
  '';

}
# RUNMAKE=runghc Setup.hs

# .PHONY: build copy install doc clean

# default: build copy

# build: src/*/*.gf
# 	$(RUNMAKE) build

# copy:
# 	$(RUNMAKE) copy

# install: build copy

# doc: build
# 	make -C doc GF_LIB_PATH=../dist


