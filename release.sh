#!/usr/bin/env zsh
# NOTE: requires zsh because of subdirectory wildstars!
set -e

git clone --depth 1 https://dawn.googlesource.com/dawn
cd dawn
git rev-parse HEAD >../dawn.ref
cd ..

rm -rf src
mkdir -p src
cp -r dawn/src/tint src/
rm -rf src/cmd
rm -rf src/**/BUILD.*
rm -rf src/**/*_test.cc
rm -rf src/**/*_bench.cc
