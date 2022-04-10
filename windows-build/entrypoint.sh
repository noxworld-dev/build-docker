#!/bin/sh
cd "${GITHUB_WORKSPACE}"
export VP="github.com/noxworld-dev/opennox/v1/internal/version"
export SHA=$(git rev-parse --short HEAD)
export VERS=$(git name-rev --tags --name-only $SHA)

mkdir -p "${GITHUB_WORKSPACE}/build"
cd "${GITHUB_WORKSPACE}/src"
export GOPATH="${GITHUB_WORKSPACE}/gocache/client/path"
export GOCACHE="${GITHUB_WORKSPACE}/gocache/client/cache"
mkdir -p "$GOPATH"
go build -o "${GITHUB_WORKSPACE}/build/opennox.exe" -ldflags="-H windowsgui -X ${VP}.commit=${SHA} -X ${VP}.version=${VERS}" ./cmd/opennox
export GOPATH="${GITHUB_WORKSPACE}/gocache/client-hd/path"
export GOCACHE="${GITHUB_WORKSPACE}/gocache/client-hd/cache"
if [ ! -d "${GITHUB_WORKSPACE}/gocache/client-hd" ]; then
cp -r "${GITHUB_WORKSPACE}/gocache/client" "${GITHUB_WORKSPACE}/gocache/client-hd"
fi
go build -o "${GITHUB_WORKSPACE}/build/opennox-hd.exe" -ldflags="-H windowsgui -X ${VP}.commit=${SHA} -X ${VP}.version=${VERS}" -tags highres ./cmd/opennox
export GOPATH="${GITHUB_WORKSPACE}/gocache/server/path"
export GOCACHE="${GITHUB_WORKSPACE}/gocache/server/cache"
if [ ! -d "${GITHUB_WORKSPACE}/gocache/server" ]; then
cp -r "${GITHUB_WORKSPACE}/gocache/client" "${GITHUB_WORKSPACE}/gocache/server"
fi
go build -o "${GITHUB_WORKSPACE}/build/opennox-server.exe" -ldflags="-X ${VP}.commit=${SHA} -X ${VP}.version=${VERS}" -tags server ./cmd/opennox
cd "${GITHUB_WORKSPACE}/build"
i686-w64-mingw32-ldd opennox.exe | sed 's/.*\=> \(.*\)/\1/' | grep -v -i "not found" | xargs -I{} cp {} .
chmod -R a+r "${GITHUB_WORKSPACE}/gocache"
