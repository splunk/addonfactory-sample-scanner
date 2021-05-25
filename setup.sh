#!/usr/bin/env bash
echo "git submodules"
pushd $GITHUB_ACTION_PATH
git submodule update --init --recursive
ls -l
pushd earlybird
./build.sh
./install.sh
popd
popd