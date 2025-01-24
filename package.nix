{ stdenv
, lib
, fetchurl
, makeWrapper
, jdk
, libxkbcommon
, libX11
, libXt
}: let
  # JNativeHook libraries needed for global hotkeys
  JNHookLibs = [
    libxkbcommon
    libX11
    libXt
  ];
in stdenv.mkDerivation rec {
  pname = "NinjaBrain-Bot";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/Ninjabrain1/${pname}/releases/download/${version}/${pname}-${version}.jar";
    hash = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = JNHookLibs;

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${pname}-${version}.jar

    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
    --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
    --set LD_LIBRARY_PATH ${lib.makeLibraryPath JNHookLibs }
  '';

}
