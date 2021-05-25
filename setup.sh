#!/usr/bin/env bash
echo "git submodules"
git submodule init
git submodule update --init --recursive
pushd earlybird
./build.sh
./install.sh
popd