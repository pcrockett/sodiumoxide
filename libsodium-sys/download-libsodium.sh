#!/bin/bash

# This script is meant for maintainers to easily update the code in the
# libsodium folder. Once the code is updated, you should commit changes to the
# repository so no one else will need to run it.

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail

VERSION="$1"
ARCHIVE_BASE_NAME="libsodium-$VERSION"
ARCHIVE_FULL_NAME="$ARCHIVE_BASE_NAME.tar.gz"
DOWNLOAD_URL="https://download.libsodium.org/libsodium/releases/$ARCHIVE_FULL_NAME"
SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
SRC_DIR="$SCRIPT_DIR/libsodium"

wget "$DOWNLOAD_URL"
wget "$DOWNLOAD_URL.sig"

gpg --no-default-keyring \
    --keyring "$SCRIPT_DIR/libsodium-signing-keys.gpg" \
    --verify "$ARCHIVE_FULL_NAME.sig"

tar -xzf "$ARCHIVE_FULL_NAME"

if [ -d "$SRC_DIR" ]; then
    rm -r "$SRC_DIR"
fi

mv "$ARCHIVE_BASE_NAME" "$SRC_DIR"
rm "$ARCHIVE_FULL_NAME"
rm "$ARCHIVE_FULL_NAME.sig"
