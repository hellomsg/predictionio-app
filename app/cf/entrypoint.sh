#!/bin/bash
export LANG="en_US.UTF-8"

set -e
#set -u
set -x

echo "input:"$1

case $1 in
    "train")
        pio app new cf
        pio eventserver 
        ;;
    "query")
        pio deploy
        ;;
esac

exit 1;
