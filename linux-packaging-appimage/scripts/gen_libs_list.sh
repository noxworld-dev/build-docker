#!/bin/sh
TMPFOLDER="/tmp/opennox-deploy-tmp"
LIBS_LIST_OUTPUT="libs_to_copy"

rm -rf $TMPFOLDER
> $LIBS_LIST_OUTPUT
mkdir $TMPFOLDER
if [ $? -gt 0 ]; then
echo "Failed to create a folder for temporary operations. Aborting."
exit 1
fi
touch $TMPFOLDER/libs_to_check

# [LIBS_TO_INCLUDE] List of libraries, which opennox uses.
cat > $TMPFOLDER/libs_to_include <<EOF
/lib/i386-linux-gnu/libSDL2-2.0.so.0
/lib/i386-linux-gnu/libopenal.so.1
EOF

# [LIBS_TO_IGNORE] List of libraries which must be excluded from the list.
# libc, libm and libpthread are part of libc6 package, which must never be distributed.
# libGL must never be distributed, because it is an important system dependant graphical library.
# libGLdispatch, libGLX are provided by libgl1 package and also vendor-dependant
cat > $TMPFOLDER/ignoredlibs <<EOF
libc.so
libm.so
libpthread.so
libGL.so
libGLX.so
libGLdispatch.so
EOF

is_lib_missing=0
is_library_ignored()
{
	ignored=0
	while read ignoredlib
	do
		if [ ! "${1##"$ignoredlib"*}" ]; then
			ignored=1
			break
		fi
	done < $TMPFOLDER/ignoredlibs
	return $ignored
}

is_library_already_checked()
{
	checked=0
	while read checkedlib
	do
		if [ "$1" = "$checkedlib" ]; then
			checked=1
			break
		fi
	done < $TMPFOLDER/libs_to_check
	return $checked
}

get_lib_dependecies()
{
	# We need only libraries.
	ldd "$1" | grep "=>" > $TMPFOLDER/lddout
	while read currentlib
	do
		libname=$(echo "$currentlib" | cut -d " " -f1)
		libpath=$(echo "$currentlib" | cut -d " " -f3)
		is_library_already_checked $libpath
		if [ $? -eq 0 ]; then
			if [ -f $libpath ]; then
				is_library_ignored $libname
				if [ $? -eq 0 ]; then
					echo "$libpath" >> $LIBS_LIST_OUTPUT
					echo "$libpath" >> $TMPFOLDER/libs_to_check
				fi
			else
				echo "Library is missing: $libname ($libpath)"
				is_lib_missing=1
			fi
		fi
	done < $TMPFOLDER/lddout
}

while read currentlib
do
	# Check if lib exists. If it is -- include it into list and retrieve its dependencies.
	if [ -f $currentlib ];then
		is_library_ignored ${currentlib##*/}
		if [ $? -eq 1 ]; then
			echo "Error: library $currentlib is not allowed for inclusion."
			rm -rf $TMPFOLDER
			exit 1
		else
			echo "$currentlib" >> $LIBS_LIST_OUTPUT
			# Retrieve dependencies
			get_lib_dependecies "$currentlib"
		fi
	else
		echo "Library not found: $lib"
		is_lib_missing=1
	fi
done < $TMPFOLDER/libs_to_include
if [ $is_lib_missing -eq 1 ]; then
	rm $LIBS_LIST_OUTPUT
	echo "Please install these libraries and run this script again"
	exit 1
else
	echo "Script work is done. List of libraries has been saved in '$LIBS_LIST_OUTPUT' file"
fi
rm -rf $TMPFOLDER
exit 0
