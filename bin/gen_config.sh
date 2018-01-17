#!/bin/sh

. "./bin/settings.sh"

if [ ! -e etc ] ; then
    mkdir etc
fi

if [ ! -d etc ] ; then
    echo "A file etc exists but is not a directory"
    exit 1
fi

#######################
# nginx config
#######################
if [ ! -e etc/nginx.key ] ; then
    pushd etc
    # creating nginx certificate
    SUBJ="/C=AU/ST=Brisbane/O=/localityName=BCCVL/commonName=${BCCVL_HOSTNAME}/organizationalUnitName=/emailAddress=/"

    openssl genrsa -out nginx.key 2048
    openssl req -new -subj "$SUBJ" -key nginx.key -out nginx.csr
    openssl x509 -req -days 365 -in nginx.csr -signkey nginx.key -out nginx.crt
    rm nginx.csr

    # create combined pem file
    cat nginx.crt nginx.key > nginx.pem
    chown 0600 nginx.pem
    popd
fi

# create nginx.conf from template
sed -e "s/HOSTNAME/${BCCVL_HOSTNAME}/g" templates/nginx.conf.in > etc/nginx.conf

#########################
# ssh config
#########################
if [ ! -e etc/bccvl.id_rsa.pub ] ; then
    # creating zope ssh key
    pushd etc
    ssh-keygen -q -f bccvl.id_rsa -N ''
    popd
fi

# make sure the keys are world readable? (avoid permission problems in dev env)
#chmod o+r etc/bccvl.id_rsa*

#########################
# bccvl config
#########################
if [ -d etc/zope.conf ] ; then
    # in case container got started early docker will cerate a directory
    rm -fr etc/zope.conf
fi
cp templates/zope.conf etc/zope.conf

# bccvl.ini file from template
if [ -d etc/bccvl.ini ] ; then
    # in case container got started early docker will cerate a directory
    rm -fr etc/bccvl.ini
fi
sed -e "s/HOSTNAME/${BCCVL_HOSTNAME}/g" templates/bccvl.ini.in > etc/bccvl.ini

# visualiser.ini file from template
if [ -d etc/visualiser.ini ] ; then
    # in case container got started early docker will cerate a directory
    rm -fr etc/visualiser.ini
fi
cp templates/visualiser.ini etc/visualiser.ini
