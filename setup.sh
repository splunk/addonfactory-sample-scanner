#!/usr/bin/env bash
git submodule update --init --recursive
pushd earlybird
./build.sh
./install.sh
popd