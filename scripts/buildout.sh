#!/bin/sh

docker-compose run --name bccvl_buildout bccvl ./bin/buildout -c compose.cfg
docker cp bccvl_buildout:/opt/bccvl/parts/instance/zope.conf ./zope.conf
docker rm bccvl_buildout
