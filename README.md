
# PSn00bSDK

PSn00bSDK is an open source homebrew software development kit for the original
Sony PlayStation, consisting of a C/C++ compiler toolchain and a set of
libraries that provide a layer of abstraction over the raw hardware in order to
make game and app development easier. A CMake-based build system, CD-ROM image
packing tool (`mkpsxiso`) and asset conversion utilities are also provided.

At the heart of PSn00bSDK is `libpsn00b`, a set of libraries that implements
most of the core functionality of the official Sony SDK (excluding higher-level
libraries) plus several new extensions to it. Most of the basic APIs commonly
used by homebrew apps and games built with the official SDK are available,
making PSn00bSDK a good starting point for those who have an existing codebase
but want to move away from Sony tools.

Currently supported features include:

* Full support for the GPU's functionality including all primitive types (lines,
  polygons, sprites) as well DMA transfers managed through a software-driven
  command queue that can optionally be extended with custom commands. Both NTSC
  and PAL video modes are fully supported.

* Extensive GTE support with rotate, translate, perspective correction and
  lighting calculation fully supported through C and/or assembly GTE macros
  paired with high speed matrix and vector helper functions. All calculations
  performed in fixed point integer math, not a single float used.

* BIOS-based interrupt dispatch system providing the ability to register custom
  callbacks for all IRQs and DMA channels while preserving compatibility with
  all functions provided by the BIOS.

* Basic support for controller input through the BIOS, with optional limited
  support for manual polling.

* Complete Serial I/O support with buffering and console driver to redirect BIOS
  standard input and output to the serial port. Hardware flow control supported.

* CD-ROM support featuring asynchronous reading, CD-DA and XA-ADPCM audio
  playback and a built-in ISO9660 file system parser with no file count limit.
  Additional support for multi-session discs and bypassing region checks on
  supported console models.

* Full MDEC support for hardware accelerated lossy image decompression and video
  playback.

* Preliminary limited support for Konami System 573 arcade hardware.

* Experimental support for dynamic linking at runtime, including function and
  variable introspection by loading a map file generated at build time.

Note that, while PSn00bSDK's API is to some extent compatible with the official
SDK's, the project is *not* meant to be a drop-in replacement for it, both
since reimplementing the entire SDK would be a major undertaking and because
many parts of it are inefficient, clunky and/or provide relatively little value.

## Tutorials and examples
See n00bdemo/default.nix on how to use this flake.

## Credits
https://github.com/Lameguy64/PSn00bSDK