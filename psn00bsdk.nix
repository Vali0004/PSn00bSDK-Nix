{ stdenv
, fetchFromGitHub
, lib
, cmake
, gnumake
, gcc
, binutils
, mipsel-embedded
}:

let
  toolchain = mipsel-embedded.buildPackages;
in stdenv.mkDerivation rec {
  pname = "psn00bsdk";
  version = "unstable-2025-08-05";
  dontUseCmakeBuildDir = true;

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "Lameguy64";
    repo = "PSn00bSDK";
    rev = "f5b439060d2724c549f2abbc2b16d7b0257ee0b8";
    hash = "sha256-Kf+mOsdBBzc+S6/I07rwumK8gbPifQiYEgbzyRZqTqc=";
  };

  nativeBuildInputs = [ cmake gnumake ];
  buildInputs = [
    gcc
    binutils
    toolchain.gcc
    toolchain.binutils
  ];

  cmakeFlags = [
    "-DPSN00BSDK_TARGET=mipsel-none-elf"
    "-DPSN00BSDK_TC=${toolchain.gcc}"
    "-DSKIP_EXAMPLES=ON"
  ];

  patches = [ ./0001-Fix-lzp-stdlib.patch ];

  installPhase = ''
    mkdir -p $out
    cp -r tree/bin tree/lib tree/include $out/
  '';
}
