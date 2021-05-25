#!/usr/bin/env bash
echo "git submodules"
pushd $GITHUB_ACTION_PATH
git submodule update --init --recursive
pushd earlybird
ls -l
./build.sh
./install.sh
popd
popd