#!/bin/sh

# TODO: xvfb-run ?

docker-compose run --rm bccvl ./bin/test $@
