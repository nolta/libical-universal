#!/bin/sh

# build.sh
# remark
#
# Created by John Clayton on 4/16/2010.
# Copyright 2010 Small Society. All rights reserved.

# Builds libical using make and whatever environment is passed in from Xcode.
# This script needs to be run from a "Run Script" build phase from an Xcode
# project in order to have the correct environment. It won't work if you just
# run it here.

set

# Set the sdk root
if [ "$SDKROOT" != "" ]; then
	ISYSROOT="-isysroot $SDKROOT"
fi

# Cd into the libical src tree
ROOT=`dirname "$0"`
LIBICALROOT="${ROOT}/libical"
cd "$LIBICALROOT"

# Determine the arch we are building. We only build the first arch that gets 
# set, so no universal binaries from Xcode, sry.
ARCHS=("$ARCHS")
BUILDARCH=${ARCHS[0]}
ARCH="-arch $BUILDARCH"
if [ "$BUILDARCH" != "i386" ]; then
	HOST="--host=arm-apple-darwin"
fi

# Output goes here
PREFIX="$DERIVED_FILES_DIR/libical"

echo "** Building libical.a for '${BUILDARCH}',  HOST=$HOST **"

# Clean
cd src/libicalss
make clean
cd ../..

make distclean
make clean
find . -name \*.a -exec rm {} \;

# Configure
env CFLAGS="-O -g $ARCH $ISYSROOT" \
	LDFLAGS="$ARCH" \
	CC=$PLATFORM_DEVELOPER_BIN_DIR/gcc \
	LD=$PLATFORM_DEVELOPER_BIN_DIR/ld \
./configure --prefix="$PREFIX" --disable-dependency-tracking $HOST

# Build
make -j4
make install

# Copy

cp "$PREFIX/lib/libical.a" "$BUILT_PRODUCTS_DIR"
cp -R "$PREFIX/share/libical" "$BUILT_PRODUCTS_DIR"
cp -R "$PREFIX/include/libical" "$BUILT_PRODUCTS_DIR"

exit 0