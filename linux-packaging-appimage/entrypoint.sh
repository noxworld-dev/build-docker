#!/bin/sh
set -e
echo "Generating libraries list..."
/scripts/gen_libs_list.sh
echo "Generating AppImage..."
/scripts/deploy.sh
echo "Moving appimage into the build directory..."
mv ${GITHUB_WORKSPACE}/opennox-bundle-i386.AppImage "${GITHUB_WORKSPACE}/build"
echo "Done"