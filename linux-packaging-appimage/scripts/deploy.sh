#!/bin/sh
# OpenNox AppImage bulder by Xandros Darkstorm (Discord for support: xandrosdarkstorm)
# Version 1.3

# Unfortunately AppImageKit project has no strict policy regarding releases.
PROJECT_FOLDER="${GITHUB_WORKSPACE}/build"
LIBS_LIST="libs_to_copy"
if [ -z $APPIMAGETOOL_RELEASE ]; then
	# Use "continuous" build to get the latest development build. You can still specify any other build (13 is the latest).
	APPIMAGETOOL_RELEASE="13"
fi

if [ -z $OPENNOX_CFG ]; then
	OPENNOX_CFG="opennox/opennox.yml"
fi
if [ -z $OPENNOX_DATA ]; then
	OPENNOX_DATA="opennox/gamedata"
fi
if [ -z $OPENNOX_STATEFILES ]; then
	OPENNOX_STATEFILES="opennox"
fi
#SIGNKEY="xandros-test-key"

exit_on_error()
{
if [ $? -gt 0 ]; then
echo "$1"
exit 1
fi
}

bundle_struct_exit_on_error()
{
exit_on_error "Failed to create bundle structure. Aborting."
}

bundle_makedir_exit_on_error()
{
exit_on_error "Failed to make directory '$1' for library. Aborting."
}

bundle_filecopy_exit_on_error()
{
exit_on_error "Failed to copy files. Aborting."
}

exit_on_build_fail()
{
exit_on_error "Failed to compile AppImage. Aborting."
}

make_dummyicon_on_fail()
{
if [ $? -gt 0 ]; then
echo "Icon not found. Making a stub icon."
touch opennox_bundle.AppDir/opennox.png
fi
}

echo "Checking appimagetool..."
if [ ! -x "./appimagetool-$APPIMAGETOOL_RELEASE.AppImage" ] || [ "$APPIMAGETOOL_RELEASE" = "continuous" ]; then
echo "Downloading appimagetool..."
wget -q --show-progress  -O appimagetool-$APPIMAGETOOL_RELEASE.AppImage "https://github.com/AppImage/AppImageKit/releases/download/$APPIMAGETOOL_RELEASE/appimagetool-i686.AppImage"
	if [ $? -gt 0 ]; then
	rm appimagetool-$APPIMAGETOOL_RELEASE.AppImage
	echo "Failed to download appimagetool. Aborting. Please check if you have an access to GitHub."
	exit 1
	fi
chmod +x appimagetool-$APPIMAGETOOL_RELEASE.AppImage
fi

echo "Preparing bundle structure..."
rm -rf opennox_bundle.AppDir
mkdir -p opennox_bundle.AppDir/usr/bin
bundle_struct_exit_on_error

echo "Copying project files..."
cp $PROJECT_FOLDER/opennox opennox_bundle.AppDir/usr/bin/opennox
bundle_filecopy_exit_on_error
chmod +x opennox_bundle.AppDir/usr/bin/opennox
cp $PROJECT_FOLDER/opennox-hd opennox_bundle.AppDir/usr/bin/opennox-hd
bundle_filecopy_exit_on_error
chmod +x opennox_bundle.AppDir/usr/bin/opennox-hd
cp $PROJECT_FOLDER/opennox-server opennox_bundle.AppDir/usr/bin/opennox-server
bundle_filecopy_exit_on_error
chmod +x opennox_bundle.AppDir/usr/bin/opennox-server

echo "Copying libraries:"
while read lib_to_copy
do
	echo "Copying $lib_to_copy..."
	libdir="opennox_bundle.AppDir$(dirname "$lib_to_copy")"
	if [ ! -d $libdir ]; then
		mkdir -p $libdir
		bundle_makedir_exit_on_error "$libdir"
	fi
	cp -v $lib_to_copy $libdir
	if [ $? -gt 0 ]; then
		bundle_filecopy_exit_on_error
	fi
done < $LIBS_LIST
echo "Libraries have been copied successfully."

echo "Generating runner script..."
cat > opennox_bundle.AppDir/AppRun <<EOF
#!/bin/sh
if [ -z \$APPDIR ]; then
	APPDIR=\$PWD
fi

if [ -z \$PATH ]; then
	OLDPATH=""
else
	OLDPATH=":"\$PATH
fi
PATH="\$APPDIR/usr/local/bin:\$APPDIR/usr/bin:\$APPDIR/bin:\$APPDIR/usr/local/games:\$APPDIR/usr/games"\$OLDPATH

if [ -z \$LD_LIBRARY_PATH ]; then
	OLDLIBSPATH=""
else
	OLDLIBSPATH=":"\$LD_LIBRARY_PATH
fi
LD_LIBRARY_PATH="\$APPDIR/usr/lib:\$APPDIR/usr/lib/i386-linux-gnu/:\$APPDIR/usr/lib/i386-linux-gnu/pulseaudio/:\$APPDIR/usr/lib32/:\$APPDIR/lib/:\$APPDIR/lib/i386-linux-gnu/:\$APPDIR/lib32/"\$OLDLIBSPATH

XDG_DATA_DIRS="/usr/local/share/:/usr/share/\$XDG_DATA_DIRS"

if [ -z \$XDG_CONFIG_HOME ]; then
	cfgpath="\$HOME/.config/$OPENNOX_CFG"
else
	cfgpath="\$XDG_CONFIG_HOME/$OPENNOX_CFG"
fi

if [ -z \$XDG_DATA_HOME ]; then
	datapath="\$HOME/.local/share/$OPENNOX_DATA"
else
	datapath="\$XDG_DATA_HOME/$OPENNOX_DATA"
fi

if [ -z \$XDG_STATE_HOME ]; then
	statepath="\$HOME/.local/state/$OPENNOX_STATEFILES"
else
	statepath="\$XDG_DATA_HOME/$OPENNOX_STATEFILES"
fi

exit_on_mkdir_error()
{
if [ \$? -gt 0 ]; then
echo "Unable to create path '\$1'. Check if you have sufficient permissions or try using portable home mode (--appimage-portable-home as first parameter)."
exit 1
fi
}

mkdir -p \$(dirname \$cfgpath)
exit_on_mkdir_error "\$(dirname \$cfgpath)"
mkdir -p "\$statepath"
exit_on_mkdir_error "\$statepath"
if [ ! -d \$datapath ]; then
mkdir -p "\$datapath"
exit_on_mkdir_error "\$datapath"
echo "Please put Nox game files here and restart the AppImage: \$datapath"
exit 2
fi

cd \$statepath

export APPDIR
export APPIMAGE
export ARGV0
export OWD
export PATH
export LD_LIBRARY_PATH

if [ "\$1" = "help" ]; then
	echo "OpenNox Appimage-specific parameters:"
	echo "\$ARGV0 hd [other parameters]"
	echo "    Run OpenNox HD."
	echo "\$ARGV0 server [other parameters]"
	echo "    Run OpenNox dedicated server."
	echo " "
	echo "OpenNox Appimage edition changes the path to files to conform to the XDG Base Directory Specification v0.8."
	echo "Your config file must be here: \$cfgpath"
	echo "Your game files must be here: \$datapath"
	echo "OpenNox log files will be stored here: \$statepath"
	echo " "
	echo "Please note, that Appimage can work in completely portable fashion: just run the AppImage like this:"
	echo "\$ARGV0 server --appimage-portable-home"
	echo "This will create folder that will serve as a portable space for the OpenNox. Then run OpenNox as usual."
	exit 0
elif [ "\$1" = "hd" ]; then
	shift 1
	opennox-hd --config=\$cfgpath --data=\$datapath "\$@"
elif [ "\$1" = "server" ]; then
	shift 1
	opennox-server --config=\$cfgpath --data=\$datapath "\$@"
else
	if [ ! -z "\$1" ]; then
		shift 1
	fi
	opennox --config=\$cfgpath --data=\$datapath "\$@"
fi
EOF
chmod +x opennox_bundle.AppDir/AppRun

echo "Generating necessary junk for AppImage builder..."
cat > opennox_bundle.AppDir/opennox-bundle.desktop <<EOF 
[Desktop Entry]
Name=opennox-bundle
Terminal=true
Exec=echo "Tweak this .desktop file to run AppRun."
Icon=opennox
Type=Application
Categories=Game
EOF
chmod +x opennox_bundle.AppDir/opennox-bundle.desktop
cp $PROJECT_FOLDER/opennox.png opennox_bundle.AppDir 2>/dev/null
make_dummyicon_on_fail

echo "Building the AppImage..."
if [ -z $SIGNKEY ]; then
echo "AppImage will not be signed."
./appimagetool-$APPIMAGETOOL_RELEASE.AppImage --appimage-extract-and-run -n --comp gzip opennox_bundle.AppDir
else
echo "AppImage will be signed with GPG key '$SIGNKEY'."
./appimagetool-$APPIMAGETOOL_RELEASE.AppImage --appimage-extract-and-run -n --comp gzip -s --sign-key $SIGNKEY opennox_bundle.AppDir
fi
exit_on_build_fail

echo "Cleaning up..."
rm -rf opennox_bundle.AppDir

echo "Script work is done."
