#!/bin/bash

source "./bin/settings.sh"

if [ "$BCCVL_HOSTNAME" == "localhost" -o "$BCCVL_HOSTNAME" == "127.0.0.1" ] ; then
    echo "Can't run testsetup with $BCCVL_HOSTNAME"
    exit 1
fi

docker-compose run --rm bccvl ./bin/instance testsetup --siteurl https://${BCCVL_HOSTNAME} $@

#docker-compose run --rm bccvl ./bin/instance testsetup $@
