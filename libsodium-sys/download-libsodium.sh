#!/bin/bash

# This script is meant for maintainers to easily update the code in the
# libsodium folder. Once the code is updated, you should commit changes to the
# repository so no one else will need to run it.

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail

VERSION="$1"
SRC_ARCHIVE_BASE_NAME="libsodium-$VERSION"
SRC_ARCHIVE_FULL_NAME="$SRC_ARCHIVE_BASE_NAME.tar.gz"
SRC_DOWNLOAD_URL="https://download.libsodium.org/libsodium/releases/$SRC_ARCHIVE_FULL_NAME"
LIB_ARCHIVE_BASE_NAME="libsodium-$VERSION-msvc"
LIB_ARCHIVE_FULL_NAME="$LIB_ARCHIVE_BASE_NAME.zip"
LIB_DOWNLOAD_URL="https://download.libsodium.org/libsodium/releases/$LIB_ARCHIVE_FULL_NAME"
SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
LIBSODIUM_DIR="$SCRIPT_DIR/libsodium"
SRC_DIR="$LIBSODIUM_DIR/src"
LIB_DIR="$LIBSODIUM_DIR/lib"

# Delete / recreate the libsodium directory
if [ -d "$LIBSODIUM_DIR" ]; then
    rm -r "$LIBSODIUM_DIR"
fi
mkdir "$LIBSODIUM_DIR"

# Download the source code, verify it, and put it in place where it belongs
wget "$SRC_DOWNLOAD_URL"
wget "$SRC_DOWNLOAD_URL.sig"

gpg --no-default-keyring \
    --keyring "$SCRIPT_DIR/libsodium-signing-keys.gpg" \
    --verify "$SRC_ARCHIVE_FULL_NAME.sig"

tar -xzf "$SRC_ARCHIVE_FULL_NAME"

mv "$SRC_ARCHIVE_BASE_NAME" "$SRC_DIR"
rm "$SRC_ARCHIVE_FULL_NAME"
rm "$SRC_ARCHIVE_FULL_NAME.sig"

# Download the precompiled libs for Windows, verify it, and put it in place where it belongs
wget "$LIB_DOWNLOAD_URL"
wget "$LIB_DOWNLOAD_URL.sig"

gpg --no-default-keyring \
    --keyring "$SCRIPT_DIR/libsodium-signing-keys.gpg" \
    --verify "$LIB_ARCHIVE_FULL_NAME.sig"

unzip "$LIB_ARCHIVE_FULL_NAME" -d "$LIB_DIR"
rm "$LIB_ARCHIVE_FULL_NAME"
rm "$LIB_ARCHIVE_FULL_NAME.sig"
