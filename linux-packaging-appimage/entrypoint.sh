#!/bin/sh
set -e
chmod -v a+x /scripts/*.sh
echo "Generating libraries list..."
./gen_libs_list.sh
echo "Generating AppImage..."
./deploy.sh
echo "Moving appimage into the build directory..."
mv opennox-bundle-i386.AppImage "${GITHUB_WORKSPACE}/build"
echo "Done"