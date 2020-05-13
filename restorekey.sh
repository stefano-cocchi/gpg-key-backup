#!/usr/bin/env bash
set -ex

DEVICE_NAME=$1

if [ -z "$DEVICE_NAME" ]; then
    >&2 echo "Device name is missing!"
    >&2 echo "Usage: $0 <key fingerprint> <device name>"
    exit 1
fi

. "`dirname $0`/vars.sh"

if [ ! -d "$MEDIA_DIR/$DEVICE_NAME" ]; then
    >&2 echo "Device \"$DEVICE_NAME\" not found!"
    exit 1
fi

if [ ! -f "$MEDIA_DIR/$DEVICE_NAME/$BACKUP_FILENAME" ]; then
    >&2 echo "Device \"$DEVICE_NAME\" does not contain a valid backup file!"
    exit 1
fi

RESTORE_TMP_DIR=`mktemp -d`

set +e
chmod 700 "$RESTORE_TMP_DIR"
unzip "$MEDIA_DIR/$DEVICE_NAME/$BACKUP_FILENAME" -d "$RESTORE_TMP_DIR"
openssl aes-256-cbc -d -base64 -md sha256 -iter 10 -in "$RESTORE_TMP_DIR/private.enc" | gpg --batch --yes --import
rm -rf "$RESTORE_TMP_DIR"
set -e

exit 0
