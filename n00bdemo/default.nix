{ stdenv
, cmake
, gnumake
, psn00bsdk
}:

stdenv.mkDerivation rec {
  name = "n00bdemo";
  dontUseCmakeBuildDir = true;

  src = ./.;
  nativeBuildInputs = [ cmake gnumake psn00bsdk ];
  buildInputs = [
    psn00bsdk
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=${psn00bsdk}/lib/libpsn00b/cmake/sdk.cmake"
  ];

  installPhase = ''
    mkdir -p $out
    cp *.elf *.map *.exe *.qlp *.lzp *.xml $out
  '';

  meta = {
    systems = [ "mipsel-none-elf" ];
  };
}