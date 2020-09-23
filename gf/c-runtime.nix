{ gf-core, stdenv, autoreconfHook }:
stdenv.mkDerivation {
  name = "gf-c-runtime-0.0.1";
  src = gf-core + "/src/runtime/c";
  nativeBuildInputs = [ autoreconfHook ];
}
