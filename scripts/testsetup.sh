#!/bin/bash

docker-compose run --rm bccvl ./bin/instance testsetup --siteurl https://${DOCKER_MACHINE_IP} $@
