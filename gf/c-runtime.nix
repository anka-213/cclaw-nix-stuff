{ stdenv, autoreconfHook }:
stdenv.mkDerivation {
  name = "gf-c-runtime-0.0.1";
  src = ../src/runtime/c;
  nativeBuildInputs = [ autoreconfHook ];
  # src = fetchurl {
  #   url = http://example.org/libfoo-1.2.3.tar.bz2;
  #   sha256 = "0x2g1jqygyr5wiwg4ma1nd7w4ydpy82z9gkcv8vh2v8dn3y58v5m";
  # };
}
