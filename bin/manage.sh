#!/bin/sh

docker-compose run --rm bccvl ./bin/instance manage "$@"
