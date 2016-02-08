#!/bin/bash

eval $(docker-machine env bccvldev)

export DOCKER_MACHINE_IP=$(docker-machine ip bccvldev)

if [ ! -e nginx.key ] ; then
    # creating nginx certificate
    SUBJ="/C=AU/ST=Brisbane/O=/localityName=BCCVL/commonName=$DOCKER_MACHINE_IP/organizationalUnitName=/emailAddress=/"

    openssl genrsa -out nginx.key 2048
    openssl req -new -subj "$SUBJ" -key nginx.key -out nginx.csr
    openssl x509 -req -days 365 -in nginx.csr -signkey nginx.key -out nginx.crt
    rm nginx.csr
fi

if [ ! -e zope.id_rsa.pub ] ; then
    # creating zope ssh key
    ssh-keygen -q -f zope.id_rsa -N ''
fi

if [ ! -e nginx.conf ] ; then
    # create nginx.conf from template
    sed -e "s/DOCKER_MACHINE_IP/${DOCKER_MACHINE_IP}/g" nginx.conf.template > nginx.conf
fi

echo "Machine IP: ${DOCKER_MACHINE_IP}"

