#!/bin/bash
set -e
export PATH=/usr/bin:$PATH
pacman -Sy --noconfirm --needed diffutils make gcc perl

PATH_TO_PACKAGE_DIR="`cygpath "$4"`"
PATH_TO_SRC_DIR="`cygpath "$5"`"

echo "FFmpegConfig.sh: $1 Platform: $2 Configuration: $3 Prefix: $PATH_TO_PACKAGE_DIR Sources: $PATH_TO_SRC_DIR"

EXTRA_CXXFLAGS=""
EXTRA_CFLAGS="-MD -DWINAPI_FAMILY=WINAPI_FAMILY_APP -D_WIN32_WINNT=0x0A00"
if [ "$3" == "debug" ]; then
	EXTRA_CFLAGS="-MDd -DWINAPI_FAMILY=WINAPI_FAMILY_APP -D_WIN32_WINNT=0x0A00"	
	EXTRA_CXXFLAGS="-MDd"
fi

EXTRA_LDFLAGS="-APPCONTAINER WindowsApp.lib"
if [ "$3" == "debug" ]; then
	EXTRA_LDFLAGS="-APPCONTAINER WindowsApp.lib -NODEFAULTLIB:libcmt"	
fi

FFMPEG_OPTIONS="--disable-programs --disable-dxva2 --enable-postproc --enable-gpl --enable-zlib --disable-devices --disable-crystalhd --enable-muxer=spdif --enable-muxer=adts --enable-muxer=asf --enable-muxer=ipod --enable-encoder=ac3 --enable-encoder=aac --enable-encoder=wmav2 --enable-encoder=png --enable-encoder=mjpeg --enable-protocol=http"
echo FFMPEG_OPTIONS:$FFMPEG_OPTIONS
echo EXTRA_CFLAGS:$EXTRA_CFLAGS
echo EXTRA_CXXFLAGS:$EXTRA_CXXFLAGS
echo EXTRA_LDFLAGS:$EXTRA_LDFLAGS

if [ "$2" == "x86" ]; then
    echo "Make Win10 x86 $3"
    "$PATH_TO_SRC_DIR/configure" $FFMPEG_OPTIONS\
    --toolchain=msvc \
    --target-os=win32 \
    --arch=x86 \
    --enable-cross-compile \
    --enable-shared \
    --disable-static \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-cxxflags="$EXTRA_CXXFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS" \
    --prefix=$PATH_TO_PACKAGE_DIR
    make -j6 && make install

elif [ "$2" == "x64" ]; then
    echo "Make Win10 x64"
    "$PATH_TO_SRC_DIR/configure" $FFMPEG_OPTIONS\
    --toolchain=msvc \
    --target-os=win32 \
    --arch=x86_64 \
    --enable-cross-compile \
    --enable-shared \
    --disable-static \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-cxxflags="$EXTRA_CXXFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS" \
    --prefix=$PATH_TO_PACKAGE_DIR
    make -j6 && make install

elif [ "$2" == "ARM" ]; then
    echo "Make Win10 ARM"
    "$PATH_TO_SRC_DIR/configure" $FFMPEG_OPTIONS\
    --toolchain=msvc \
    --target-os=win32 \
    --arch=arm \
    --as=armasm \
    --cpu=armv7 \
    --enable-cross-compile \
    --enable-thumb \
    --enable-shared \
    --disable-static \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-cxxflags="$EXTRA_CXXFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS" \
    --prefix=$PATH_TO_PACKAGE_DIR
    make -j6 && make install
fi

exit 0