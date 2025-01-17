{ stdenv
, lib
, fetchurl
, makeWrapper
, jdk
, libxkbcommon
, libX11
, libXt
}: let
  JNHookLibs = [
    libxkbcommon
    libX11
    libXt
  ];
in stdenv.mkDerivation rec {
  name = "NinjaBrain-Bot";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/Ninjabrain1/${name}/releases/download/1.5.1/${name}-${version}.jar";
    hash = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = JNHookLibs;

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar

    makeWrapper ${jdk}/bin/java $out/bin/${name} \
    --add-flags "-jar $out/share/java/${name}-${version}.jar" \
    --set LD_LIBRARY_PATH ${lib.makeLibraryPath JNHookLibs }
  '';

}
