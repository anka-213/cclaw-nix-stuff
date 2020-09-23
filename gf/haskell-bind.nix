{ mkDerivation, base, containers, gu, pgf, pretty, stdenv }:
mkDerivation {
  pname = "pgf2";
  version = "1.2.1";
  src = ../src/runtime/haskell-bind;
  libraryHaskellDepends = [ base containers pretty ];
  librarySystemDepends = [ gu pgf ];
  homepage = "https://www.grammaticalframework.org";
  description = "Bindings to the C version of the PGF runtime";
  license = stdenv.lib.licenses.lgpl3;
}
