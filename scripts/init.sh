#!/bin/bash

# TODO: create ssh keys, ssl certs, and other stuff here

docker pull hub.bccvl.org.au/bccvl/bccvl

# get initial zope.conf so that bccvl zope can be started up via compose (it has an image dependency)
# TODO: if zope.conf is a directry remove it
cid=$(docker create hub.bccvl.org.au/bccvl/bccvl)
docker cp ${cid}:/opt/bccvl/parts/instance/etc/zope.conf ./zope.conf
docker rm ${cid}

# TODO: bring postgis up and wait
docker-compose exec --user postgres postgis createuser plone
docker-compose exec --user postgres postgis createdb -O plone plone
docker-compose exec --user postgres postgis psql -c "alter user plone with password 'plone';"

docker-compose exec --user postgres postgis createuser visualiser
docker-compose exec --user postgres postgis createdb -O visualiser visualiser
docker-compose exec --user postgres postgis psql -c "alter user visualiser with password 'visualiser';"
docker-compose exec --user postgres postgis psql -d visualiser -c "CREATE EXTENSION postgis;"


# fix up visualiser permissions when running on sharedtmp
docker-compose run --rm visualiser chown -R visualiser:visualiser /var/opt/visualiser/{bccvl,visualiser,visualiser_public}



###################
## Stuff below no longer needed ... keyt for reference
###################

## TODO: make sure rabbitmq is running
##       docker-compose up -d rabbitmq
#docker exec rabbitmq rabbitmqctl add_vhost bccvl
#docker exec rabbitmq rabbitmqctl add_user bccvl bccvl
#docker exec rabbitmq rabbitmqctl set_permissions -p bccvl bccvl '.*' '.*' '.*'
#docker exec rabbitmq rabbitmqctl set_permissions -p bccvl admin '.*' '.*' '.*'

## TODO: make sure swift is up and running
##       docker-compose up -d swift
## Initialise swauth (assumes swift runs in container named swift)
#docker run --rm --link swift hub.bccvl.org.au/openstack/swiftaio:2.5.0 swauth-prep -A $SW_AUTH_URL -K swauthkey
## Install webadmin files (accessible at http(s)://<host>:<port>/auth/)
#docker run --rm --link swift -w /usr/share/doc/python-swauth/webadmin hub.bccvl.org.au/openstack/swiftaio:2.5.0 swift -A $AUTH_URL -U .super_admin:.super_admin -K swauthkey upload .webadmin .
## add a test user
#docker run --rm --link swift hub.bccvl.org.au/openstack/swiftaio:2.5.0 swauth-add-user -A $SW_AUTH_URL -K swauthkey -a test tester testing
