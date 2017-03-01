#!/bin/sh

# TONES:
#   after changes to buildout rerun docker-compose build bccvl
#   run this script once to create source clones in files/src -> TODO: maybe use another folder?
#       and generate .egg-info folders

if [ -e './.env' ] ; then
    . './.env'
fi

docker-compose run --rm -e "ADMIN_PASS=${C9_PASS:-admin}" bccvl buildout
