#!/usr/bin/env bash
set -ex

KEY_FINGERPRINT=$1
DEVICE_NAME=$2

if [ -z "$KEY_FINGERPRINT" ]; then
    >&2 echo "Key fingerprint is missing!"
    >&2 echo "Usage: $0 <key fingerprint> <device name>"
    exit 1
fi

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

if [ -f "$MEDIA_DIR/$DEVICE_NAME/$BACKUP_FILENAME" ]; then
    >&2 echo "Device already contains a backup!"
    >&2 echo "Run the following command to delete it"
    >&2 echo "rm \"$MEDIA_DIR/$DEVICE_NAME/$BACKUP_FILENAME\""
    exit 1
fi

BACKUP_TMP_DIR=`mktemp -d`

set +e
touch "$BACKUP_TMP_DIR/private.enc"
chmod 600 "$BACKUP_TMP_DIR/private.enc"
gpg --batch --yes --export-secret-keys --armor "$KEY_FINGERPRINT" | openssl aes-256-cbc -base64 -md sha256 -iter 10 -out "$BACKUP_TMP_DIR/private.enc"
if [ $? -ne 0 ]; then     
    rm -rf "$BACKUP_TMP_DIR"    
    >&2 echo "Backup failed!"
    exit 1
fi
set -e

zip -j "$BACKUP_TMP_DIR/private.zip" "$BACKUP_TMP_DIR/private.enc"
cat "`dirname $0`/image.jpg" "$BACKUP_TMP_DIR/private.zip" > "$MEDIA_DIR/$DEVICE_NAME/$BACKUP_FILENAME"
rm -rf "$BACKUP_TMP_DIR"
exit 0