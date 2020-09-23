{ mkDerivation
, alex
, array
, base
, bytestring
, Cabal
, cgi
, containers
, directory
, exceptions
, fail
, filepath
, ghc-prim
, happy
, haskeline
, httpd-shed
, json
, mtl
, network
, network-uri
, parallel
, pretty
, process
, random
, stdenv
, terminfo
, time
, transformers-compat
, unix
, utf8-string
}:
mkDerivation {
  pname = "gf";
  version = "3.10.4";
  src = ./..;
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  setupHaskellDepends = [ base Cabal directory filepath process ];
  libraryHaskellDepends = [
    array
    base
    bytestring
    cgi
    containers
    directory
    exceptions
    fail
    filepath
    ghc-prim
    haskeline
    httpd-shed
    json
    mtl
    network
    network-uri
    parallel
    pretty
    process
    random
    terminfo
    time
    transformers-compat
    unix
    utf8-string
  ];
  libraryToolDepends = [ alex happy ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base Cabal directory filepath process ];
  doCheck = false;
  postPatch = ''
    sed -i "s|\"-s\"|\"\"|" ./Setup.hs
    sed -i "s|numJobs (bf bi)++||" ./Setup.hs
  '';
  preBuild = ''export LD_LIBRARY_PATH=`pwd`/dist/build''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH'';
  homepage = "http://www.grammaticalframework.org/";
  description = "Grammatical Framework";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
