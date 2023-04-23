#!/bin/sh
set -e
cd "${GITHUB_WORKSPACE}"
git config --global --add safe.directory "${GITHUB_WORKSPACE}"
mkdir -p "${GITHUB_WORKSPACE}/build"
cd "${GITHUB_WORKSPACE}/src"
export GOPATH="${GITHUB_WORKSPACE}/gocache/path"
export GOCACHE="${GITHUB_WORKSPACE}/gocache/cache"
go run ./internal/noxbuild -o "${GITHUB_WORKSPACE}/build"
cd "${GITHUB_WORKSPACE}/build"
chmod -R a+r "${GITHUB_WORKSPACE}/gocache"
