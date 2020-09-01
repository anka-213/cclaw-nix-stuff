{ stdenv, ghc, gf }:

stdenv.mkDerivation {
  name = "gf-rgl";
  # src = ./.;
  buildInputs = [ghc gf];
  # doc requirements: [graphviz-nox]
  src = fetchTarball {
    url = "https://github.com/GrammaticalFramework/gf-rgl/archive/master.tar.gz";
    sha256 = "12jxqvdjj8zhafz92c05pd96k1wa8z9dvgkjaxxvb20kmk1gq0xm";
  };
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


