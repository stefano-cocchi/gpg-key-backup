#!/usr/bin/env bash
2>&1 echo "Pipe in text, or paste and it ctrl-d when done"
PASSPHRASE=`cat - | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-zA-Z]/ /g' -e 's/\r\n/ /g' | awk '{$1=$1}1'`
echo "---BEGIN PASSPHRASE---"
echo -e $PASSPHRASE
echo "---END PASSPHRASE---"