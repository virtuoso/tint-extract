#!/usr/bin/env zsh
# NOTE: requires zsh because of subdirectory wildstars!
set -e

git clone --depth 1 https://dawn.googlesource.com/dawn
cd dawn
git rev-parse HEAD >../dawn.ref
cd ..

rm -rf src
rm -rf include
mkdir -p src/tint
mkdir -p src/utils
mkdir -p include

cp dawn/src/utils/*.h src/utils/
cp -r dawn/src/tint/api src/tint
cp -r dawn/src/tint/lang src/tint
cp -r dawn/src/tint/utils src/tint
cp -r dawn/include/tint include

rm -rf src/**/BUILD.*
rm -rf src/**/*_test.cc
rm -rf src/**/*_bench.cc
rm -rf src/**/*_fuzz.cc

# remove some files to reduce dependencies (we only need SPIRV reading and WGSL writing)
rm -rf src/tint/lang/core/ir/binary
rm -rf src/tint/lang/glsl
rm -rf src/tint/lang/hlsl
rm -rf src/tint/lang/msl
rm -rf src/tint/lang/wgsl/ls
