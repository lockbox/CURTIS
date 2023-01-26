#!/usr/bin/env bash

mkdir -p build
pushd build
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/arm_toolchain.cmake ..
make
popd