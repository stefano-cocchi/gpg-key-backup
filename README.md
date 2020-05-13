# gpg-key-backup
Backup GPG private keys to storage devices
## Usage
### Backup a key
```
./backupkey.sh <key fingerprint> <devicename>
```
### Restore a key from backup
```
./restorekey.sh <device name>
```
### Environment Variables
Name | Default value | Description
--- | --- | ---
BACKUP_FILENAME | cat.jpg | Defines a custom filename for the key backup
MEDIA_DIR | /media/$USER | Controls where backup devices are located
