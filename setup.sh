#!/usr/bin/env bash
git submodule update --recursive
pushd earlybird
./build.sh
./install.sh
popd