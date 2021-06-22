# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "LHAPDF"
version = v"6.3.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://lhapdf.hepforge.org/downloads/?f=LHAPDF-$(version).tar.gz",
                  "ed4d8772b7e6be26d1a7682a13c87338d67821847aa1640d78d67d2cef8b9b5d")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/LHAPDF*/
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target} --disable-python
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms(; experimental=true)

# The products that we will ensure are always built
products = [
    LibraryProduct("libLHAPDF", :libLHAPDF)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version=v"6")
