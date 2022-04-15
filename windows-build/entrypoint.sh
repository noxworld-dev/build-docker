#!/bin/sh
cd "${GITHUB_WORKSPACE}"
git config --global --add safe.directory "${GITHUB_WORKSPACE}"
mkdir -p "${GITHUB_WORKSPACE}/build"
cd "${GITHUB_WORKSPACE}/src"
export GOPATH="${GITHUB_WORKSPACE}/gocache/path"
export GOCACHE="${GITHUB_WORKSPACE}/gocache/cache"
go build -buildvcs=false -o noxbuild ./internal/noxbuild
export LD_LIBRARY_PATH=/usr/i686-w64-mingw32/lib
export C_INCLUDE_PATH=/usr/i686-w64-mingw32/include
./noxbuild --os windows -o "${GITHUB_WORKSPACE}/build"
cd "${GITHUB_WORKSPACE}/build"
i686-w64-mingw32-ldd opennox.exe | sed 's/.*\=> \(.*\)/\1/' | grep -v -i "not found" | xargs -I{} cp {} .
chmod -R a+r "${GITHUB_WORKSPACE}/gocache"
