# HouvilainenFilter

Author: Eric Sluyter

Port of filter described by Antti Houvilainen in text "Non linear digital implementation of the moog ladder filter"

### Requirements

- CMake >= 3.5
- SuperCollider source code

### Building

Clone the project, then use CMake to configure and build it. If you start from a directory that
contains the directory where you cloned SuperCollider, the following commands will work.

    git clone https://esluyter/houvilainenfilter
    cd houvilainenfilter
    mkdir build
    cd build

Then, depending on your toolchain:

    # Linux + make
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make -j
    make install

    # macOS + Xcode
    cmake .. -GXcode -DSC_PATH=/path/to/supercollider
    cmake --build . --config Release

    # Windows + VS 2017
    cmake .. -G"Visual Studio 15 2017 Win64"
    cmake --build . --config Release
    cmake --build . --config Release --target Install

You may want to manually specify the install location in the first step to point it at your
SuperCollider extensions directory: add the option `-DCMAKE_INSTALL_PREFIX=/path/to/extensions`.

### Developing

Use the command in `regenerate` to update CMakeLists.txt when you add or remove files from the
project. You don't need to run it if you only change the contents of existing files. You may need to
edit the command if you add, remove, or rename plugins, to match the new plugin paths. Run the
script with `--help` to see all available options.
