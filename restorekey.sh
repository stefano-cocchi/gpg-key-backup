#!/usr/bin/env bash
set -exo pipefail

DEVICE_NAME=$1

if [ ! -f "$DEVICE_NAME" ]; then
    >&2 echo "Device \"$DEVICE_NAME\" not found!"
    exit 1
fi

RESTORE_TMP_DIR=`mktemp -d`

cleanup(){
	test -d "$RESTORE_TMP_DIR" && rm -rf "$RESTORE_TMP_DIR"
}

trap cleanup EXIT

chmod 700 "$RESTORE_TMP_DIR"
unzip "$DEVICE_NAME" -d "$RESTORE_TMP_DIR" || true
test -f "$RESTORE_TMP_DIR/private.enc" || (>&2 echo "Device \"$DEVICE_NAME\" does not contain any key."; exit 1)
openssl aes-256-cbc -d -base64 -md sha256 -iter 10 -in "$RESTORE_TMP_DIR/private.enc" | gpg --batch --yes --import
exit 0
